//
//  Endpoints.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import Foundation


enum Endpoints {
    case authors
    case categories
    case books
    
    case singleAuthor(authorID: String)
    case singleCategory(categoryID: String)
    case singleBooks(bookSlug: String)
    
    private var baseURL: URLComponents {
        var baseURL: URLComponents = URLComponents()
        baseURL.host = "playground-bookstore.herokuapp.com"
        baseURL.scheme = "https"
        baseURL.path = "/api/v1/"
        return baseURL
    }
    
    var completeURL: URL? {
        var baseURL: URLComponents = baseURL
        switch self {
        case .authors:
            baseURL.path += "authors"
        case .categories:
            baseURL.path += "categories"
        case .books:
            baseURL.path += "books"
        case .singleBooks(let bookSlug):
            baseURL.path += "books/\(bookSlug)"
        case .singleAuthor(let authorID):
            baseURL.path += "authors/\(authorID)"
        case .singleCategory(let categoryID):
            baseURL.path += "categories/\(categoryID)"
        }
        return baseURL.url
    }
}
