//
//  Books+TableViewViewable.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import Foundation

extension Book: ResultViewable {
    var name: String {
        return self.attributes.title
    }
    var dataType: DataType {
        return .Book
    }
    
    var slug: String? {
        return self.attributes.slug
    }
    
    var content: String? {
        return self.attributes.content
    }
}
