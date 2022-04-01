//
//  Categories.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import Foundation

// MARK: - Categories
struct CategoriesResponse: Codable {
    let data: [Category]
}

struct SingleCategoryResponse: Codable {
    let data: Category
}

// MARK: - Datum
struct Category: Codable {
    let id: String
    let attributes: CategoryAttributes
    let relationships: CategoryRelationships
    let links: CategoryLinks
}

// MARK: - Attributes
struct CategoryAttributes: Codable {
    let name, slug: String
}

// MARK: - DatumLinks
struct CategoryLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Relationships
struct CategoryRelationships: Codable {
    let books: CategoryBooks
}

// MARK: - Books
struct CategoryBooks: Codable {
    let links: CategoryBooksLinks
}

// MARK: - BooksLinks
struct CategoryBooksLinks: Codable {
    let linksSelf, related: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case related
    }
}
