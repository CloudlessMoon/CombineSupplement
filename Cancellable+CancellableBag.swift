//
//  Cancellable+.swift
//  CombineSupplement
//
//  Created by jiasong on 2026/6/30.
//

import Foundation
import Combine

extension Cancellable {
    
    public func cancelled(by bag: CancellableBag) {
        bag.insert(self)
    }
    
}
