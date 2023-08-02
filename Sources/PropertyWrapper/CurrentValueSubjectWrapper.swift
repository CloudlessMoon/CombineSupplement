//
//  CurrentValueSubjectWrapper.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

@propertyWrapper public final class CurrentValueSubjectWrapper<Element> {
    
    public fileprivate(set) var projectedValue: CurrentValueSubjectProjected<Element>
    
    public var wrappedValue: Element {
        get {
            guard let queue = self.projectedValue.queue else {
                return self.projectedValue.currentValueSubject.value
            }
            return queue.combine.safeSync {
                return self.projectedValue.currentValueSubject.value
            }
        }
        set {
            guard let queue = self.projectedValue.queue else {
                self.projectedValue.currentValueSubject.send(newValue)
                return
            }
            queue.combine.safeSync {
                self.projectedValue.currentValueSubject.send(newValue)
            }
        }
    }
    
    public init(wrappedValue: Element) {
        self.projectedValue = CurrentValueSubjectProjected(wrappedValue: wrappedValue)
    }
    
}

public final class CurrentValueSubjectProjected<Element> {
    
    private var _queue: DispatchQueue?
    public var queue: DispatchQueue? {
        get {
            self.lock.lock(); defer { self.lock.unlock() }
            return self._queue
        }
        set {
            self.lock.lock(); defer { self.lock.unlock() }
            self._queue = newValue
            self._queue?.combine.registerSpecific()
        }
    }
    
    public var publisher: AnyPublisher<Element, Never> {
        return self.currentValueSubject.eraseToAnyPublisher()
    }
    
    fileprivate let currentValueSubject: CurrentValueSubject<Element, Never>
    private let lock = NSRecursiveLock()
    
    fileprivate init(wrappedValue: Element) {
        self.currentValueSubject = CurrentValueSubject(wrappedValue)
    }
    
}
