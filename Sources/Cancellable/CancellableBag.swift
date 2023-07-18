//
//  CancellableBag.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

private struct CancellableAssociatedKeys {
    static var bag: String = "combine_cancellable_bag"
}

public protocol CancellableBag: AnyObject {
    
    var cancellableBag: Set<AnyCancellable> { get set }
}

public extension CancellableBag {
    
    private func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        return action()
    }
    
    var cancellableBag: Set<AnyCancellable> {
        get {
            return self.synchronizedBag {
                if let cancellableBag = objc_getAssociatedObject(self, &CancellableAssociatedKeys.bag) as? Set<AnyCancellable> {
                    return cancellableBag
                }
                let cancellableBag = Set<AnyCancellable>()
                objc_setAssociatedObject(self, &CancellableAssociatedKeys.bag, cancellableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellableBag
            }
        }
        set {
            self.synchronizedBag {
                objc_setAssociatedObject(self, &CancellableAssociatedKeys.bag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
