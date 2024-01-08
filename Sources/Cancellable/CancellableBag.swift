//
//  CancellableBag.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

private struct CancellableAssociatedKeys {
    static var bag: UInt8 = 0
    static var lock: UInt8 = 0
}

public typealias AnyCancellables = [AnyCancellable]

public protocol CancellableBag: AnyObject {
    
    var cancellableBag: AnyCancellables { get set }
}

public extension CancellableBag {
    
    var cancellableBag: AnyCancellables {
        get {
            return self.safeValue {
                if let cancellableBag = objc_getAssociatedObject(self, &CancellableAssociatedKeys.bag) as? AnyCancellables {
                    return cancellableBag
                }
                let cancellableBag: AnyCancellables = []
                objc_setAssociatedObject(self, &CancellableAssociatedKeys.bag, cancellableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellableBag
            }
        }
        set {
            self.safeValue {
                objc_setAssociatedObject(self, &CancellableAssociatedKeys.bag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    private var lock: NSLock {
        let initialize = {
            let value = NSLock()
            value.name = "com.ruanmei.combine-supplement.cancellable-bag"
            objc_setAssociatedObject(self, &CancellableAssociatedKeys.lock, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return (objc_getAssociatedObject(self, &CancellableAssociatedKeys.lock) as? NSLock) ?? initialize()
    }
    
    private func safeValue<T>(execute work: () -> T) -> T {
        self.lock.lock(); defer { self.lock.unlock() }
        return work()
    }
}
