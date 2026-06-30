//
//  AnyObject+CancellableBag.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine
import ThreadSafe

public extension CombineWrapper where Base: AnyObject {
    
    var cancellableBag: CancellableBag {
        get {
            return self._cancellableBag.value
        }
        set {
            self._cancellableBag.value = newValue
        }
    }
    
    private var _cancellableBag: UnfairLockValue<CancellableBag> {
        if let cancellableBag = objc_getAssociatedObject(self, &AssociatedKeys.cancellableBag) as? UnfairLockValue<CancellableBag> {
            return cancellableBag
        } else {
            let cancellableBag = UnfairLockValue(CancellableBag())
            objc_setAssociatedObject(self, &AssociatedKeys.cancellableBag, cancellableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return cancellableBag
        }
    }
    
}

private enum AssociatedKeys {
    static var cancellableBag: UInt8 = 0
}
