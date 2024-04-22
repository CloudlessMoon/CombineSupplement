//
//  AnyCancellableBag.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

private struct AnyCancellableBagAssociatedKeys {
    static var bag: UInt8 = 0
    static var lock: UInt8 = 0
}

public typealias AnyCancellables = [AnyCancellable]

public protocol AnyCancellableBag: AnyObject {
    
    var cancellableBag: AnyCancellables { get set }
}

public extension AnyCancellableBag {
    
    var cancellableBag: AnyCancellables {
        get {
            return self.safeValue {
                if let cancellableBag = objc_getAssociatedObject(self, &AnyCancellableBagAssociatedKeys.bag) as? AnyCancellables {
                    return cancellableBag
                }
                let cancellableBag: AnyCancellables = []
                objc_setAssociatedObject(self, &AnyCancellableBagAssociatedKeys.bag, cancellableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellableBag
            }
        }
        set {
            self.safeValue {
                objc_setAssociatedObject(self, &AnyCancellableBagAssociatedKeys.bag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    private var lock: NSLock {
        let initialize = {
            let value = NSLock()
            value.name = "com.ruanmei.combine-supplement.any-cancellable-bag"
            objc_setAssociatedObject(self, &AnyCancellableBagAssociatedKeys.lock, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return (objc_getAssociatedObject(self, &AnyCancellableBagAssociatedKeys.lock) as? NSLock) ?? initialize()
    }
    
    private func safeValue<T>(execute work: () -> T) -> T {
        self.lock.lock(); defer { self.lock.unlock() }
        return work()
    }
}
