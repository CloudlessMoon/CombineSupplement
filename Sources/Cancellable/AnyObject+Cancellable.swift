//
//  AnyObject+Cancellable.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

private struct CancellableAssociatedKeys {
    static var bag: String = "combine_cancellable_bag"
}

public extension CombineWrapper where Base: AnyObject {
    
    private func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self.base); defer { objc_sync_exit(self.base) }
        return action()
    }
    
    var cancellableBag: AnyCancellables {
        get {
            return self.synchronizedBag {
                if let cancellableBag = objc_getAssociatedObject(self.base, &CancellableAssociatedKeys.bag) as? AnyCancellables {
                    return cancellableBag
                }
                let cancellableBag: AnyCancellables = []
                objc_setAssociatedObject(self.base, &CancellableAssociatedKeys.bag, cancellableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellableBag
            }
        }
        set {
            self.synchronizedBag {
                objc_setAssociatedObject(self.base, &CancellableAssociatedKeys.bag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
}
