//
//  Author+TableViewViewable.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import Foundation

extension Authors: ResultViewable {
    var slug: String? {
        return nil
    }
    
    var name: String {
        return self.attributes.name
    }
    var dataType: DataType {
        return .Author
    }
    
    var content: String? {
        return nil
    }
}
