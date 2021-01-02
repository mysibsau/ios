//
//  EventsCellDelegate.swift
//  my-sibgu
//
//  Created by art-off on 01.01.2021.
//

import Foundation

protocol EventsCellDelegate {
    
    func setAndReload(cellMode: EventCellMode, at indexPath: IndexPath)
    
}
