//
//  ViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 20.03.2025.
//

import UIKit

// MARK: - Protocols

protocol ImagesListViewControllerProtocol: AnyObject {
    func batchUpdateTableView(from: Int, to: Int)
    func showLikeAlert()
    func navigateToDetail(for indexPath: IndexPath)
    func showLoader()
    func hideLoader()
}

// MARK: - ImagesListViewController

final class ImagesListViewController: UIViewController {
    
    // MARK: - Props
    
    var presenter: ImagesListViewPresenterProtocol?
    
    // MAKR: UI Elements
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .ypBlack
        
        view.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Configuration
    
    private func setupAppearance() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard
            let photo = presenter?.photoAt(indexPath: indexPath),
            let photoUrl = URL(string: photo.thumbImageURL)
        else { return }
        
        cell.configureWith(
            imageUrl: photoUrl,
            date: photo.createdAt,
            isLiked: photo.isLiked
        )
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else { return }
        
        if presenter.shouldLoadNextPage(currentIndexPath: indexPath) {
            presenter.loadNextPage()
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photoAt(indexPath: indexPath) else { return 0}

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        if imageWidth == 0 {
            return 0
        }
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetail(for: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let presenter
        else { return }
        
        presenter.changeLikeAt(indexPath: indexPath) { isLike in
            cell.setIsLiked(isLiked: isLike)
        }
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func navigateToDetail(for indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        guard
            let photo = presenter?.photoAt(indexPath: indexPath),
            let photoUrl = URL(string: photo.largeImageURL)
        else { return }
        
        viewController.setImage(imageUrl: photoUrl)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController,animated: true)
    }

    private enum LikeAllertCaptions {
        static let title = "Что-то пошло не так"
        static let message = "Не удалось изменить лайк"
    }

    func batchUpdateTableView(from: Int, to: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (from..<to).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func showLikeAlert() {
        let alert = buildAllert(
            withTitle: LikeAllertCaptions.title,
            andMessage: LikeAllertCaptions.message
        )
        present(alert, animated: true)
    }
    
    func showLoader() {
        UIBlockingProgressHUD.show()
    }

    func hideLoader() {
        UIBlockingProgressHUD.dismiss()
    }
 
}
