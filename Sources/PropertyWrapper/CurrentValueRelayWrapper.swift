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
    
    public init(wrappedValue: Element, task: ReadWriteTask = .init(label: "com.jiasong.combine-supplement.current-value-relay")) {
        self.projectedValue = CurrentValueRelayProjected(wrappedValue: wrappedValue, task: task)
    }
    
}

public final class CurrentValueRelayProjected<Element> {
    
    @UnfairLockValueWrapper
    public var task: ReadWriteTask
    
    public var publisher: AnyPublisher<Element, Never> {
        return self.relay.eraseToAnyPublisher()
    }
    
    private let relay: CurrentValueRelay<Element>
    
    fileprivate init(wrappedValue: Element, task: ReadWriteTask) {
        self.relay = CurrentValueRelay(value: wrappedValue)
        self.task = task
    }
    
    fileprivate var value: Element {
        get {
            return self.task.read { self.relay.value }
        }
        set {
            self.task.write { self.relay.send(newValue) }
        }
    }
    
}
