//
//  CurrentValueRelayWrapper.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

@propertyWrapper public final class CurrentValueRelayWrapper<Element> {
    
    public private(set) var projectedValue: CurrentValueRelayProjected<Element>
    
    public var wrappedValue: Element {
        get {
            guard let queue = self.projectedValue.queue else {
                return self.projectedValue.relay.value
            }
            
            return queue.combine.safeSync {
                return self.projectedValue.relay.value
            }
        }
        set {
            guard let queue = self.projectedValue.queue else {
                self.projectedValue.relay.send(newValue)
                return
            }
            
            queue.combine.safeSync {
                self.projectedValue.relay.send(newValue)
            }
        }
    }
    
    public init(wrappedValue: Element) {
        self.projectedValue = CurrentValueRelayProjected(wrappedValue: wrappedValue)
    }
    
}

public final class CurrentValueRelayProjected<Element> {
    
    fileprivate let relay: CurrentValueRelay<Element>
    
    private let lock: AllocatedUnfairLock<DispatchQueue?>
    
    fileprivate init(wrappedValue: Element) {
        self.relay = CurrentValueRelay(value: wrappedValue)
        self.lock = AllocatedUnfairLock(state: nil)
    }
    
}

extension CurrentValueRelayProjected {
    
    public var queue: DispatchQueue? {
        get {
            self.lock.withLock { $0 }
        }
        set {
            self.lock.withLock { $0 = newValue }
        }
    }
    
    public var publisher: AnyPublisher<Element, Never> {
        return self.relay.eraseToAnyPublisher()
    }
    
}
