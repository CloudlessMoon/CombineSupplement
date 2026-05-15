//
//  AtomicInt.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/12/17.
//

import Foundation
import ThreadSafe

public final class AtomicInt: @unchecked Sendable {
    
    public var value: UInt {
        return self.lockValue.value
    }
    
    private let lockValue: UnfairLockValue<UInt>
    
    public init(_ value: UInt) {
        self.lockValue = UnfairLockValue(value)
    }
    
}

extension AtomicInt {
    
    @discardableResult
    public func mutating(execute work: (inout UInt) throws -> Void) rethrows -> UInt {
        return try self.lockValue.mutating(execute: work)
    }
    
}
