//
//  LabelButton.swift
//  my-sibgu
//
//  Created by art-off on 03.03.2021.
//

import UIKit

class LabelButton: CenterLabelView {
    
    var action: (() -> Void)!
    
    init(text: String, action: @escaping () -> Void) {
        super.init(text: text)
        self.action = action
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.action()
    }
    
}
