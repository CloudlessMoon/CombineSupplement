//
//  CurrentValueRelay.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/4/26.
//

import Foundation
import Combine

/// Unlike `CurrentValueSubject` it can't terminate with error or completed.
public final class CurrentValueRelay<Output>: Publisher {
    
    public typealias Output = Output
    public typealias Failure = Never
    
    public var value: Output {
        return self.subject.value
    }
    
    private let subject: CurrentValueSubject<Output, Never>
    
    public init(value: Output) {
        self.subject = CurrentValueSubject(value)
    }
    
    public func send(_ value: Output) {
        self.subject.send(value)
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
        self.subject.receive(subscriber: subscriber)
    }
    
    public func eraseToAnyPublisher() -> AnyPublisher<Output, Never> {
        return self.subject.eraseToAnyPublisher()
    }
    
}
