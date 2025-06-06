//
//  SplashViewPresenterTests.swift
//  ImageFeedTests
//
//  Created by Вадим Суханов on 04.06.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileViewPresenterTests: XCTestCase {
    func testLogout_CallShowsLogoutAllert() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceDummy()
        let imageService = ProfileImageServiceDummy()
        let logoutService = ProfileLogoutServiceSpy()
        let presenter = ProfileViewPresenter(
            logoutService: logoutService,
            imageService: imageService,
            profileService: profileService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.logout()
        
        //then
        XCTAssert(viewController.showLogoutAlertCalled)
    }
    
    func testLogout_CallDoesLogout() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceDummy()
        let imageService = ProfileImageServiceDummy()
        let logoutService = ProfileLogoutServiceSpy()
        let presenter = ProfileViewPresenter(
            logoutService: logoutService,
            imageService: imageService,
            profileService: profileService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.logout()
        
        //then
        XCTAssert(logoutService.logoutCalled)
    }
    
    func testLogout_CallNavigatesToSplash() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceDummy()
        let imageService = ProfileImageServiceDummy()
        let logoutService = ProfileLogoutServiceSpy()
        let presenter = ProfileViewPresenter(
            logoutService: logoutService,
            imageService: imageService,
            profileService: profileService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.logout()
        
        //then
        XCTAssert(viewController.navigateToSplashScreenCalled)
    }
}
