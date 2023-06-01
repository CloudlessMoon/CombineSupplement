//
//  AnyObject+Cancellable.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

fileprivate var cancellableBagAnyObject: UInt8 = 0

public extension CombineWrapper where Base: AnyObject {
    
    fileprivate func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        return action()
    }
    
    var cancellableBag: Set<AnyCancellable> {
        get {
            return self.synchronizedBag {
                if let cancellableBag = objc_getAssociatedObject(self.base, &cancellableBagAnyObject) as? Set<AnyCancellable> {
                    return cancellableBag
                }
                let cancellableBag = Set<AnyCancellable>()
                objc_setAssociatedObject(self.base, &cancellableBagAnyObject, cancellableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cancellableBag
            }
        }
        set {
            self.synchronizedBag  {
                objc_setAssociatedObject(self.base, &cancellableBagAnyObject, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
}
