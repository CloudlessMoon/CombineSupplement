//
//  DispatchQueue+Extension.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation

private struct QueueReference {
    weak var queue: DispatchQueue?
}

private struct QueueAssociatedKeys {
    static var specific: String = "combine_specific_key"
}

extension CombineWrapper where Base: DispatchQueue {
    
    func safeSync<T>(execute work: () -> T) -> T {
        if let value = DispatchQueue.getSpecific(key: self.detectionKey) {
            if value.queue == self.base {
                return work()
            } else {
                return self.base.sync(execute: work)
            }
        } else {
            let value = self.base.getSpecific(key: self.detectionKey)
            if value == nil || value?.queue != self.base {
                self.base.setSpecific(key: self.detectionKey, value: QueueReference(queue: self.base))
            }
            return self.base.sync(execute: work)
        }
    }
    
    private var detectionKey: DispatchSpecificKey<QueueReference> {
        if let specific = objc_getAssociatedObject(self.base, &QueueAssociatedKeys.specific) as? DispatchSpecificKey<QueueReference> {
            return specific
        }
        let specific = DispatchSpecificKey<QueueReference>()
        objc_setAssociatedObject(self.base, &QueueAssociatedKeys.specific, specific, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return specific
    }
    
}
