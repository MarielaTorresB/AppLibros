//
//  DetailViewController.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewableResultFromDashboard: ResultViewable?
    private var fetchedResult: ResultViewable?
    
    private var apiDataManager: APIDataManager = APIDataManager()
    
    private var bookImage: UIImageView = UIImageView()
    private var headerTitle: DetailViewHeader?
    private lazy var activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        requestDetailInfo()
    }
    
    private func initUI() {
        view.backgroundColor = .systemBackground
        self.title = Constants.detailViewTitle
    }
    
    private func requestDetailInfo() {
        guard let model: ResultViewable = viewableResultFromDashboard else { return }
        createActivityIndicator()
        switch model.dataType {
        case .Category: requestCategoryDetail()
        case .Book: requestBookDetail()
        case .Author: requestAuthorDetail()
        }
        
    }
    
    private func requestBookDetail() {
        guard let slug: String = viewableResultFromDashboard?.slug else { return }
        apiDataManager.performRequest(endpoint: .singleBooks(bookSlug: slug)) { [weak self] (dataResponse: SingleBookResponse) in
            self?.fetchedResult = dataResponse.data
            self?.completeUI()
        } onError: { error in
            print(error)
        }

    }
    
    private func requestCategoryDetail() {
        guard let id: String = viewableResultFromDashboard?.id else { return }
        apiDataManager.performRequest(endpoint: .singleCategory(categoryID: id)) { [weak self] (category: SingleCategoryResponse) in
            self?.fetchedResult = category.data
            self?.completeUI()
        } onError: { error in
            print(error)
        }
    }

    private func requestAuthorDetail() {
        guard let id: String = viewableResultFromDashboard?.id else { return }
        apiDataManager.performRequest(endpoint: .singleAuthor(authorID: id)) { [weak self] (author: SingleAuthorResponse) in
            self?.fetchedResult = author.data
            self?.completeUI()
        } onError: { error in
            print(error)
        }
    }
    
    func createActivityIndicator() {
        self.view.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        activityView.startAnimating()
    }
    
    func removeActivityIndicator() {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
    
    func completeUI() {
        removeActivityIndicator()
        guard let fetchedResult = fetchedResult else {
            return
        }
        
        bookImage.image = UIImage(named: "book")
        view.addSubview(bookImage)
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        
        let title: String = fetchedResult.name
        let headerView: DetailViewHeader = DetailViewHeader(frame: CGRect.zero, title: title)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding+50),
            bookImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookImage.widthAnchor.constraint(equalToConstant: 150),
            bookImage.heightAnchor.constraint(equalToConstant: 150),
            headerView.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: Constants.padding),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        guard let content: String = fetchedResult.content else { return }
        
        let contentView: DetailViewBody = DetailViewBody(frame: CGRect.zero, content: content, section: "Detail")
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.padding),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
