//
//  TappableView.swift
//  my-sibgu
//
//  Created by Artem Rylov on 21.08.2021.
//

import UIKit

class TappableView: UIView {
    
    private var _action: () -> Void = { }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func action(_ action: @escaping () -> Void) {
        _action = action
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    @objc private func didTap() {
        _action()
    }
}
