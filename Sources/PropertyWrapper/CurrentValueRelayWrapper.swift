//
//  CurrentValueRelayWrapper.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

@propertyWrapper public struct CurrentValueRelayWrapper<Value> {
    
    public static subscript<EnclosingSelf: AnyObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get {
            return object[keyPath: storageKeyPath].relay.value
        }
        set {
            object[keyPath: storageKeyPath].relay.send(newValue)
        }
    }
    
    public var projectedValue: CurrentValueRelayProjected<Value> {
        return CurrentValueRelayProjected(self.relay)
    }
    
    @available(*, unavailable, message: "@CurrentValueRelayWrapper is only available on properties of classes")
    public var wrappedValue: Value {
        get { fatalError() }
        nonmutating set { fatalError() }
    }
    
    private let relay: CurrentValueRelay<Value>
    
    public init(wrappedValue: Value) {
        self.relay = CurrentValueRelay(value: wrappedValue)
    }
    
}

extension CurrentValueRelayWrapper: CustomStringConvertible {
    
    public var description: String {
        return String(describing: self.relay.value)
    }
    
}

public struct CurrentValueRelayProjected<Value> {
    
    private let relay: CurrentValueRelay<Value>
    
    fileprivate init(_ relay: CurrentValueRelay<Value>) {
        self.relay = relay
    }
    
}

extension CurrentValueRelayProjected {
    
    public var publisher: AnyPublisher<Value, Never> {
        return self.relay.eraseToAnyPublisher()
    }
    
}
