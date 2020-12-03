//
//  ControlTimetableDelegate.swift
//  my-sibgu
//
//  Created by art-off on 03.12.2020.
//

import Foundation

protocol ControlTimetableDelegate: class {
    
    func popTimetableViewController()
    
    func setWeekNumber(number: Int)
    
    func setControlIsUserInteractionEnabled(_ a: Bool)
    
}
