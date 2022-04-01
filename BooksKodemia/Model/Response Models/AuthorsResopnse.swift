//
//  AuthorsResopnse.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import Foundation

struct AuthorsResponse: Codable {
    let data: [Authors]
}

struct SingleAuthorResponse: Codable {
    let data: Authors
}

// MARK: - Datum
struct Authors: Codable {
    let id: String
    let attributes: AuthorAttributes
    let relationships: AuthorRelationships
    let links: AuthorLinks
}

// MARK: - Attributes
struct AuthorAttributes: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - DatumLinks
struct AuthorLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Relationships
struct AuthorRelationships: Codable {
    let books: AuthorBooks
}

// MARK: - Books
struct AuthorBooks: Codable {
    let links: AuthorBooksLinks
}

// MARK: - BooksLinks
struct AuthorBooksLinks: Codable {
    let linksSelf, related: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case related
    }
}
