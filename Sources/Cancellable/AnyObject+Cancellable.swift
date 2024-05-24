//
//  AnyObject+Cancellable.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

private struct CancellableAssociatedKeys {
    static var lock: UInt8 = 0
}

public extension CombineWrapper where Base: AnyObject {
    
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
            objc_setAssociatedObject(self.base, &CancellableAssociatedKeys.lock, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return (objc_getAssociatedObject(self.base, &CancellableAssociatedKeys.lock) as? AllocatedUnfairLock<AnyCancellables>) ?? initialize()
    }
    
}
