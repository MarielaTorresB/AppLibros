//
//  DetailViewHeader.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import UIKit

class DetailViewHeader: UIView {
    
    private var titleLabel: UILabel?
    
    private var imageBook: UIImageView?
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        initUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI(title: "")
    }
    
    func set(title: String) {
        titleLabel?.text = title
    }
    
    func initUI(title: String) {
        let label: UILabel = UILabel()
        titleLabel = label
        addSubview(label)
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.detailViewHeaderFont
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        // Constraints
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
        
        layer.masksToBounds = true
    }

}
