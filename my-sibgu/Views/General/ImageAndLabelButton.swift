//
//  ImageAndLabelButton.swift
//  my-sibgu
//
//  Created by art-off on 27.12.2020.
//

import UIKit

class ImageAndLabelButton: ImageAndLabelView {
    
    var action: (() -> Void)!
    
    init(text: String, imageName: String, action: @escaping () -> Void) {
        super.init(text: text, imageName: imageName)
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
