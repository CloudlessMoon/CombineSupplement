//
//  CurrentValueRelayWrapper.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine
import ThreadSafe

@propertyWrapper public final class CurrentValueRelayWrapper<Element> {
    
    public let projectedValue: CurrentValueRelayProjected<Element>
    
    public var wrappedValue: Element {
        get {
            return self.projectedValue.value
        }
        set {
            self.projectedValue.value = newValue
        }
    }
    
    public init(wrappedValue: Element) {
        self.projectedValue = CurrentValueRelayProjected(wrappedValue: wrappedValue)
    }
    
}

public final class CurrentValueRelayProjected<Element> {
    
    public var publisher: AnyPublisher<Element, Never> {
        return self.relay.eraseToAnyPublisher()
    }
    
    fileprivate var value: Element {
        get {
            return self.relay.value
        }
        set {
            self.relay.send(newValue)
        }
    }
    
    private let relay: CurrentValueRelay<Element>
    
    fileprivate init(wrappedValue: Element) {
        self.relay = CurrentValueRelay(value: wrappedValue)
    }
    
}
