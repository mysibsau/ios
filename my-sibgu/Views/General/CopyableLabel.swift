//
//  CopyableLabel.swift
//  my-sibgu
//
//  Created by art-off on 28.12.2020.
//

import UIKit

class CopyableLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    func sharedInit() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }
    
    @objc func showMenu(sender: AnyObject?) {
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: self.bounds)
        }
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
    
}
