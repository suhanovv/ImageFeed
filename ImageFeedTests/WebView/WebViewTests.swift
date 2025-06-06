//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Вадим Суханов on 31.05.2025.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view
        
        //then
        XCTAssert(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssert(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.5
        
        //when
        let shouldGideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldGideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        let shouldGideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldGideProgress)
    }
    
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "12345")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "12345")
    }
}
