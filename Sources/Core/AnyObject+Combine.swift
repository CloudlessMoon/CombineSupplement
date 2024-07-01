//
//  AnyObject+Combine.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/6/28.
//

import Foundation
import Combine

private struct AssociatedKeys {
    static var deallocated: UInt8 = 0
}

public extension CombineWrapper where Base: AnyObject {
    
    var deallocated: AnyPublisher<Void, Never> {
        if let deinitPublisher = objc_getAssociatedObject(self.base, &AssociatedKeys.deallocated) as? DeinitPublisher {
            return deinitPublisher.publisher
        }
        
        let deinitPublisher = DeinitPublisher()
        objc_setAssociatedObject(self.base, &AssociatedKeys.deallocated, deinitPublisher, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return deinitPublisher.publisher
    }
    
}

private final class DeinitPublisher {
    
    private let subject = PassthroughSubject<Void, Never>()
    
    fileprivate init() {
        
    }
    
    deinit {
        self.subject.send()
        self.subject.send(completion: .finished)
    }
    
    fileprivate var publisher: AnyPublisher<Void, Never> {
        return self.subject.eraseToAnyPublisher()
    }
    
}
