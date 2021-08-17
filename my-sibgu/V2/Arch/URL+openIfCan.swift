//
//  URL+openIfCan.swift
//  my-sibgu
//
//  Created by Artem Rylov on 17.08.2021.
//

import UIKit

extension URL {
    
    func openIfCan() {
        if UIApplication.shared.canOpenURL(self) {
            UIApplication.shared.open(self)
        }
    }
}
