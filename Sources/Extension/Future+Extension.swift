//
//  Future+Extension.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/3/25.
//

import Foundation
import Combine

extension Future {
    
    public convenience init(on queue: DispatchQueue, _ attemptToFulfill: @escaping (@escaping Future<Output, Failure>.Promise) -> Void) {
        self.init { promise in
            queue.async {
                attemptToFulfill(promise)
            }
        }
    }
    
    @discardableResult
    public func finally(_ handler: (() -> Void)? = nil) -> AnyCancellable {
        return self.sink { completion in
            guard case .finished  = completion else {
                return
            }
            handler?()
        } receiveValue: { _ in
            
        }
    }
    
}
