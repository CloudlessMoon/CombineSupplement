//
//  AtomicInt.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/12/17.
//

import Foundation
import ThreadSafe

public final class AtomicInt: @unchecked Sendable {
    
    public var value: Int {
        return self.lock.withLock {
            return self.count
        }
    }
    
    private var count: Int
    
    private let lock = UnfairLock()
    
    public init(_ value: Int) {
        self.count = value
    }
    
}

extension AtomicInt {
    
    public func set(_ value: Int) {
        self.lock.withLock {
            self.count = value
        }
    }
    
    public func add(_ value: Int) {
        self.lock.withLock {
            var count = self.count
            count += value
            self.count = count
        }
    }
    
    public func subtract(_ value: Int) {
        self.lock.withLock {
            var count = self.count
            count -= value
            self.count = count
        }
    }
    
    public func increment() {
        self.add(1)
    }
    
    public func decrement() {
        self.subtract(1)
    }
    
}
