//
//  AnyCancellableBag.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

private struct AnyCancellableBagAssociatedKeys {
    static var lock: UInt8 = 0
}

public typealias AnyCancellables = [AnyCancellable]

public protocol AnyCancellableBag: AnyObject {
    
    var cancellableBag: AnyCancellables { get set }
}

public extension AnyCancellableBag {
    
    var cancellableBag: AnyCancellables {
        get {
            self.lock.withLock { $0 }
        }
        set {
            self.lock.withLock { $0 = newValue }
        }
    }
    
    private var lock: AllocatedUnfairLock<AnyCancellables> {
        let initialize = {
            let value = AllocatedUnfairLock(state: AnyCancellables())
            objc_setAssociatedObject(self, &AnyCancellableBagAssociatedKeys.lock, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return (objc_getAssociatedObject(self, &AnyCancellableBagAssociatedKeys.lock) as? AllocatedUnfairLock<AnyCancellables>) ?? initialize()
    }
    
}
