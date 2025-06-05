//
//  ImageServiceMock.swift
//  ImageFeedTests
//
//  Created by Вадим Суханов on 04.06.2025.
//
@testable import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var showLikeAlertCalled = false
    var navigateToDetailCalled = false
    var batchUpdateTableViewCalled = false
    var showLoaderCalled = false
    var hideLoaderCalled = false
    
    func batchUpdateTableView(from: Int, to: Int) {
        batchUpdateTableViewCalled = true
    }

    func showLikeAlert() {
        showLikeAlertCalled = true
    }

    func navigateToDetail(for indexPath: IndexPath) {
        navigateToDetailCalled = true
    }

    func showLoader() {
        showLoaderCalled = true
    }

    func hideLoader() {
        hideLoaderCalled = true
    }
}
