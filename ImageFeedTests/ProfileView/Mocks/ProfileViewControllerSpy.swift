//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Вадим Суханов on 31.05.2025.
//
@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    var showLogoutAlertCalled = false
    var navigateToSplashScreenCalled = false
    
    
    func showLogoutAlert(okHandler: @escaping () -> Void) {
        showLogoutAlertCalled = true
        okHandler()
    }

    func updateName(name: String) {
        
    }

    func updateLogin(login: String) {
        
    }

    func updateAvatar(url: URL) {
        
    }

    func updateDescription(description: String) {
        
    }

    func navigateToSplashScreen() {
        navigateToSplashScreenCalled = true
    }
}
