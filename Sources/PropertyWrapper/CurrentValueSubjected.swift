//
//  CurrentValueSubjected.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation
import Combine

@propertyWrapper public final class CurrentValueSubjected<Element> {
    
    public var wrappedValue: Element {
        get {
            return self.currentValueSubject.value
        }
        set {
            self.currentValueSubject.send(newValue)
        }
    }
    
    fileprivate let currentValueSubject: CurrentValueSubject<Element, Never>
    
    public init(wrappedValue: Element) {
        self.currentValueSubject = CurrentValueSubject(wrappedValue)
    }
    
    public var projectedValue: any Publisher<Element, Never> {
        return self.currentValueSubject
    }
    
}
