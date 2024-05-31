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
    
    public private(set) var projectedValue: CurrentValueRelayProjected<Element>
    
    public var wrappedValue: Element {
        get {
            return self.projectedValue.value
        }
        set {
            self.projectedValue.value = newValue
        }
    }
    
    public init(wrappedValue: Element, taskLabel: String? = nil) {
        self.projectedValue = CurrentValueRelayProjected(wrappedValue: wrappedValue, taskLabel: taskLabel)
    }
    
}

public final class CurrentValueRelayProjected<Element> {
    
    @UnfairLockValueWrapper
    public var task: ReadWriteTask
    
    public var publisher: AnyPublisher<Element, Never> {
        return self.relay.eraseToAnyPublisher()
    }
    
    private let relay: CurrentValueRelay<Element>
    
    fileprivate init(wrappedValue: Element, taskLabel: String? = nil) {
        self.relay = CurrentValueRelay(value: wrappedValue)
        self.task = ReadWriteTask(label: taskLabel ?? "com.jiasong.combine-supplement.current-value-relay")
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
