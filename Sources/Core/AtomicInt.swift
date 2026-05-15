//
//  AtomicInt.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/12/17.
//

import Foundation
import ThreadSafe

public final class AtomicInt: @unchecked Sendable {
    
    @UnfairLockValueWrapper
    public private(set) var value: UInt
    
    public init(_ value: UInt) {
        self.value = value
    }
    
}

extension AtomicInt {
    
    @discardableResult
    public func mutating(execute work: (inout UInt) throws -> Void) rethrows -> UInt {
        return try self.$value.mutating(execute: work)
    }
    
}
