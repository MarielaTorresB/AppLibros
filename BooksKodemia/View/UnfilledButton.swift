//
//  UnfilledButton.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import UIKit



class UnfilledButton: UIButton {
    
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        initUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initUI(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .clear
        layer.masksToBounds = true
        layer.cornerRadius = Constants.cornerRadius
//        layer.borderWidth = Constants.borderWidth
//        layer.borderColor = UIColor.kodemiaCyan.cgColor
    }
}


