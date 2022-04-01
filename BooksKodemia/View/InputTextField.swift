//
//  InputTextField.swift
//  BooksKodemia
//
//  Created by Mariela Torres on 11/03/22.
//

import UIKit
//1.Agregando la extensión para el borde inferior(https://stackoverflow.com/questions/31107994/how-to-only-show-bottom-border-of-uitextfield-in-swift)

extension UITextField {
    internal func addBottomBorder(height: CGFloat = 1.0, color: UIColor = .black) {
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderView)
        NSLayoutConstraint.activate(
            [
                borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.heightAnchor.constraint(equalToConstant: height)
            ]
        )
    }
}

class InputTextField: UITextField {
    
    var changedValue: (() -> ())?
    
    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    weak var nextTextFieldToResign: UITextField?

    init(frame: CGRect, placeHolder: String) {
        super.init(frame: frame)
        self.placeholder = placeHolder
        applyUI()
        self.autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyUI()
    }
    
    func applyUI() {
//        layer.masksToBounds = true
//        layer.cornerRadius = Constants.cornerRadius
//        layer.borderWidth = Constants.borderWidth
//        layer.borderColor = UIColor.kodemiaCyan.cgColor
        // 2. Aplicando el método de la extensión
        self.addBottomBorder()
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
