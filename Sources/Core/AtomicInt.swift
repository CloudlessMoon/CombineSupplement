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
    public func add(_ value: UInt) -> UInt {
        return self.mutating { $0 += value }
    }
    
    @discardableResult
    public func subtract(_ value: UInt) -> UInt {
        return self.mutating { $0 -= value }
    }
    
    @discardableResult
    public func increment() -> UInt {
        return self.add(1)
    }
    
    @discardableResult
    public func decrement() -> UInt {
        return self.subtract(1)
    }
    
    @discardableResult
    public func mutating(execute work: (inout UInt) throws -> Void) rethrows -> UInt {
        return try self.lockValue.mutating(execute: work)
    }
    
}
