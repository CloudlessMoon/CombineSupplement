//
//  CancellableBag.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

fileprivate var cancellableBagContext: UInt8 = 0

public protocol CancellableBag: AnyObject {
    
    var cancellableBag: Set<AnyCancellable> { get set }
}

public extension CancellableBag {
    
    fileprivate func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        return action()
    }
    
    var cancellableBag: Set<AnyCancellable> {
        get {
            return self.synchronizedBag {
                if let cancellableBag = objc_getAssociatedObject(self, &cancellableBagContext) as? Set<AnyCancellable> {
                    return cancellableBag
                }
                let cancellableBag = Set<AnyCancellable>()
                objc_setAssociatedObject(self, &cancellableBagContext, cancellableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellableBag
            }
        }
        set {
            self.synchronizedBag  {
                objc_setAssociatedObject(self, &cancellableBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}


