//
//  SplashViewPresenterTests.swift
//  ImageFeedTests
//
//  Created by Вадим Суханов on 04.06.2025.
//

@testable import ImageFeed
import XCTest


final class ImagesListViewPresenterTests: XCTestCase {
    
    func testPhotoAt_ReturnedCorrectPhoto_ForValidIndex() {
        //given
        let photos: [Photo] = [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                description: "about",
                thumbImageURL: "http://thubmnail.com/1",
                largeImageURL: "http://large.com/1",
                isLiked: false
            ),
            Photo(
                id: "2",
                size: CGSize(width: 200, height: 100),
                createdAt: Date(),
                description: "about",
                thumbImageURL: "http://thubmnail.com/2",
                largeImageURL: "http://large.com/2",
                isLiked: false
            ),
        ]
        let imageListService = ImageListServiceMock(photos: photos)
        let presenter = ImagesListViewPresenter(imageService: imageListService)
        
        //when
        let photo = presenter.photoAt(indexPath: IndexPath(row: 0, section: 0))
        
        //then
        XCTAssertEqual(photo, photos[0])
    }
    
    func testPhotoAt_ReturnedNil_ForInValidIndex() {
        //given
        let photos: [Photo] = [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                description: "about",
                thumbImageURL: "http://thubmnail.com/1",
                largeImageURL: "http://large.com/1",
                isLiked: false
            ),
            Photo(
                id: "2",
                size: CGSize(width: 200, height: 100),
                createdAt: Date(),
                description: "about",
                thumbImageURL: "http://thubmnail.com/2",
                largeImageURL: "http://large.com/2",
                isLiked: false
            ),
        ]
        let imageListService = ImageListServiceMock(photos: photos)
        let presenter = ImagesListViewPresenter(imageService: imageListService)
        
        //when
        let photo = presenter.photoAt(indexPath: IndexPath(row: 3, section: 0))
        
        //then
        XCTAssertNil(photo)
    }
    
    func testShouldLoadNextPage_True_WhenCurrenCellIsLast() {
        //give
        let imageListService = ImageListServiceMock(photos: [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                description: "about",
                thumbImageURL: "http://thubmnail.com/1",
                largeImageURL: "http://large.com/1",
                isLiked: false
            ),
        ])
        let presenter = ImagesListViewPresenter(imageService: imageListService)
        
        //when
        let result = presenter.shouldLoadNextPage(currentIndexPath: IndexPath(row: 0, section: 0))
        
        //then
        XCTAssertTrue(result == true)
    }
    
    func testPhotosCount_ReturnsCorrectCount() {
        //give
        let imageListService = ImageListServiceMock(photos: [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                description: "about",
                thumbImageURL: "http://thubmnail.com/1",
                largeImageURL: "http://large.com/1",
                isLiked: false
            ),
        ])
        let presenter = ImagesListViewPresenter(imageService: imageListService)
        
        //when
        let result = presenter.photosCount()
        
        //then
        XCTAssertTrue(result == 1)
    }
    
    func testLoadNextPage_CalledServiceNextPage() {
        //give
        let imageListService = ImageListServiceMock(photos: [])
        let presenter = ImagesListViewPresenter(imageService: imageListService)
        
        //when
        presenter.loadNextPage()
        
        //then
        XCTAssertTrue(imageListService.fetchPhotosNextPageCalled)
    }
    
    func testChangeLike_serviceCalledWithCompletionCalled() {
        //given
        let imageListService = ImageListServiceMock(photos: [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                description: "about",
                thumbImageURL: "http://thubmnail.com/1",
                largeImageURL: "http://large.com/1",
                isLiked: false
            ),
        ])
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(imageService: imageListService)
        presenter.view = viewController
        var comletionCalled = false
        
        //when
        presenter.changeLikeAt(indexPath: IndexPath(row: 0, section: 0)) { _ in
            comletionCalled = true
        }
        
        //then
        XCTAssertTrue(comletionCalled)
    }
    
    func testChangeLike_serviceCalledWithWithoutCompletionCalledAndShowAllert() {
        //given
        let imageListService = ImageListServiceMock(photos: [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: Date(),
                description: "about",
                thumbImageURL: "http://thubmnail.com/1",
                largeImageURL: "http://large.com/1",
                isLiked: false
            ),
        ], isChangeLikeError: true)
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(imageService: imageListService)
        presenter.view = viewController
        var comletionCalled = false
        
        //when
        presenter.changeLikeAt(indexPath: IndexPath(row: 0, section: 0)) { _ in
            comletionCalled = true
        }
        
        //then
        XCTAssertFalse(comletionCalled)
        XCTAssertTrue(viewController.showLikeAlertCalled)
    }
}
