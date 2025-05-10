//
//  ViewController.swift
//  ImageFeed
//
//  Created by Вадим Суханов on 20.03.2025.
//

import UIKit

// MARK: - ImagesListViewController

final class ImagesListViewController: UIViewController {
    
    // MARK: - Props
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier: String = "ShowSingleImage"
    
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
        guard let cellImage = UIImage(named: photosName[indexPath.row]) else { return }
        guard let likeStatusImage = UIImage(
            named: indexPath.row % 2 == 0 ? "like_button_off" : "like_button_on"
        ) else { return }
        
        cell.configure(with: cellImage, and: Date(), and: likeStatusImage)
    }
    
    private func showSingleImage(for indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        let image = UIImage(named: photosName[indexPath.row])
        viewController.setImage(image: image)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
        
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        if imageWidth == 0 {
            return 0
        }
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showSingleImage(for: indexPath)
    }
}
