//
//  Unreachable.swift
//  my-sibgu
//
//  Created by Artem Rylov on 13.08.2021.
//

import Foundation

func unreachable(_ reportingReason: String? = nil, file: StaticString = #file, line: UInt = #line)  {
    assertionFailure("Unreachable: \(reportingReason ?? "no reason provided")", file: file, line: line)
}

@inline(__always)
func guardUnreachable() { guardUnreachable(()) }

@inline(__always)
func guardUnreachable<T>(_ x: T, _ reportingReason: String = "Unreachable guard failed") -> T {
    unreachable(reportingReason)
    return x
}
