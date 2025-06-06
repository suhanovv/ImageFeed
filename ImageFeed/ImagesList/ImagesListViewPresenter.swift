//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 01.06.2025.
//

import Foundation

// MARK: - Protocols

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func photoAt(indexPath: IndexPath) -> Photo?
    func photosCount() -> Int
    func shouldLoadNextPage(currentIndexPath: IndexPath) -> Bool
    func loadNextPage()
    func changeLikeAt(indexPath: IndexPath, completion: @escaping ((Bool) -> Void))
}

// MARK: - ImagesListViewPresenter

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {

    weak var view: ImagesListViewControllerProtocol?
    private var currentImagesCount: Int = 0
    private var imageServiceObserver: NSObjectProtocol?
    
    private let imageService: ImageListServiceProtocol
    
    init(imageService: ImageListServiceProtocol) {
        self.imageService = imageService
    }
    
    func viewDidLoad() {
        subscribeToImageServiceUpdates()
        imageService.fetchPhotosNextPage()
    }
    
    func photoAt(indexPath: IndexPath) -> Photo? {
        imageService.photos[safe: indexPath.row]
    }
    
    func shouldLoadNextPage(currentIndexPath: IndexPath) -> Bool {
        currentIndexPath.row + 1 == imageService.photos.count
    }
    
    func photosCount() -> Int {
        imageService.photos.count
    }

    func loadNextPage() {
        imageService.fetchPhotosNextPage()
    }
    
    func changeLikeAt(indexPath: IndexPath, completion: @escaping ((Bool) -> Void)) {
        guard let photo = imageService.photos[safe: indexPath.row] else { return }
        
        view?.showLoader()
        imageService.changeLike(photoId: photo.id, isLike: !photo.isLiked) {[weak self] result in
            guard let self else { return }
            self.view?.hideLoader()
            
            switch result {
            case .success:
                guard let photo = self.photoAt(indexPath: indexPath)
                else { return }
                completion(photo.isLiked)
            case .failure(let error):
                guard let view = self.view else { return }
                view.showLikeAlert()
                Logger.error("Error: \(error)")
            }
        }
    }
    
    private func subscribeToImageServiceUpdates() {
        imageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImageListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.photosDidUpdate()
            }
    }
    
    private func photosDidUpdate() {
        let newCount = imageService.photos.count
        if currentImagesCount != newCount {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.view?.batchUpdateTableView(from: self.currentImagesCount, to: newCount)
                self.currentImagesCount = newCount
            }
            
        }
    }
 
}
