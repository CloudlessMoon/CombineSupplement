//
//  AnyObject+Cancellable.swift
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

public extension CombineWrapper where Base: AnyObject {
    
    var cancellableBag: AnyCancellables {
        get {
            return self.lock.withLock {
                if let cancellableBag = objc_getAssociatedObject(self.base, &CancellableAssociatedKeys.bag) as? AnyCancellables {
                    return cancellableBag
                }
                let cancellableBag: AnyCancellables = []
                objc_setAssociatedObject(self.base, &CancellableAssociatedKeys.bag, cancellableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellableBag
            }
        }
        set {
            self.lock.withLock {
                objc_setAssociatedObject(self.base, &CancellableAssociatedKeys.bag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    private var lock: NSLock {
        let initialize = {
            let value = NSLock()
            objc_setAssociatedObject(self.base, &CancellableAssociatedKeys.lock, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return (objc_getAssociatedObject(self.base, &CancellableAssociatedKeys.lock) as? NSLock) ?? initialize()
    }
    
}
