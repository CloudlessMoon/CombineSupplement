//
//  CurrentValueSubjectWrapper.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

@propertyWrapper public final class CurrentValueSubjectWrapper<Element> {
    
    public private(set) var projectedValue: CurrentValueSubjectProjected<Element>
    
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
            self.safeValue {
                return self._queue
            }
        }
        set {
            self.safeValue {
                self._queue = newValue
            }
        }
    }
    
    public var publisher: AnyPublisher<Element, Never> {
        return self.currentValueSubject.eraseToAnyPublisher()
    }
    
    fileprivate let currentValueSubject: CurrentValueSubject<Element, Never>
    
    private lazy var lock: os_unfair_lock_t = {
        let lock: os_unfair_lock_t = .allocate(capacity: 1)
        lock.initialize(to: os_unfair_lock())
        return lock
    }()
    
    fileprivate init(wrappedValue: Element) {
        self.currentValueSubject = CurrentValueSubject(wrappedValue)
    }
    
    deinit {
        self.lock.deinitialize(count: 1)
        self.lock.deallocate()
    }
    
    private func safeValue<T>(execute work: () -> T) -> T {
        os_unfair_lock_lock(self.lock); defer { os_unfair_lock_unlock(self.lock) }
        return work()
    }
    
}
