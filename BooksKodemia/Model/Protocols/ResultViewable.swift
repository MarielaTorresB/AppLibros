//
//  TableViewViewable.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import Foundation

protocol ResultViewable {
    var name: String { get }
    var id: String { get }
    var dataType: DataType { get }
    var slug: String? { get }
    var content: String? { get }
}

