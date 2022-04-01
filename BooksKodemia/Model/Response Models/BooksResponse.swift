//
//  BooksResponse.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import Foundation

// MARK: - Welcome
struct BooksResponse: Codable {
    let data: [Book]
}

struct SingleBookResponse: Codable {
    let data: Book
}

// MARK: - Datum
struct Book: Codable {
    let type, id: String
    let attributes: BookAttributes
    let relationships: BookRelationships
    let links: BookLinks
}

// MARK: - Attributes
struct BookAttributes: Codable {
    let title, slug, content: String

    enum CodingKeys: String, CodingKey {
        case title, slug, content
    }
}

// MARK: - DatumLinks
struct BookLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Relationships
struct BookRelationships: Codable {
    let authors, categories: BookAuthors
}

// MARK: - Authors
struct BookAuthors: Codable {
    let links: BookAuthorsLinks
}

// MARK: - AuthorsLinks
struct BookAuthorsLinks: Codable {
    let linksSelf, related: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case related
    }
}
