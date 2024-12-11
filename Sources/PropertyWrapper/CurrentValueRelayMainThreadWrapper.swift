//
//  CurrentValueRelayMainThreadWrapper.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/12/11.
//

import Foundation
import Combine
import ThreadSafe

@propertyWrapper public final class CurrentValueRelayMainThreadWrapper<Element> {
    
    public let projectedValue: CurrentValueRelayMainThreadProjected<Element>
    
    public var wrappedValue: Element {
        get {
            return self.projectedValue.value
        }
        set {
            self.projectedValue.value = newValue
        }
    }
    
    public init(wrappedValue: Element) {
        self.projectedValue = CurrentValueRelayMainThreadProjected(wrappedValue: wrappedValue)
    }
    
}

public final class CurrentValueRelayMainThreadProjected<Element> {
    
    public var publisher: AnyPublisher<Element, Never> {
        return self.relay.eraseToAnyPublisher()
    }
    
    private let task = MainThreadTask.default
    private let relay: CurrentValueRelay<Element>
    
    fileprivate init(wrappedValue: Element) {
        self.relay = CurrentValueRelay(value: wrappedValue)
    }
    
    fileprivate var value: Element {
        get {
            return self.task.sync {
                return self.relay.value
            }
        }
        set {
            self.task.sync {
                self.relay.send(newValue)
            }
        }
    }
    
}
