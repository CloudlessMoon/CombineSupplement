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
            guard let dataQueue = self.projectedValue.dataQueue else {
                return self.projectedValue.currentValueSubject.value
            }
            return dataQueue.combine.safeSync {
                return self.projectedValue.currentValueSubject.value
            }
        }
        set {
            guard let dataQueue = self.projectedValue.dataQueue else {
                self.projectedValue.currentValueSubject.send(newValue)
                return
            }
            dataQueue.combine.safeSync {
                self.projectedValue.currentValueSubject.send(newValue)
            }
        }
    }
    
    public init(wrappedValue: Element) {
        self.projectedValue = CurrentValueSubjectProjected(wrappedValue: wrappedValue)
    }
    
}

public final class CurrentValueSubjectProjected<Element> {
    
    private var _dataQueue: DispatchQueue?
    public var dataQueue: DispatchQueue? {
        get {
            self.lock.lock(); defer { self.lock.unlock() }
            return self._dataQueue
        }
        set {
            self.lock.lock(); defer { self.lock.unlock() }
            self._dataQueue = newValue
            self._dataQueue?.combine.registerSpecific()
        }
    }
    
    public var publisher: any Publisher<Element, Never> {
        return self.currentValueSubject
    }
    
    fileprivate let currentValueSubject: CurrentValueSubject<Element, Never>
    private let lock = NSRecursiveLock()
    
    fileprivate init(wrappedValue: Element) {
        self.currentValueSubject = CurrentValueSubject(wrappedValue)
    }
    
}
