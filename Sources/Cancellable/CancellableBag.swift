//
//  CancellableBag.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/6/28.
//

import Foundation
import Combine
import ThreadSafe

extension Cancellable {
    
    public func cancelled(by bag: CancellableBag) {
        bag.insert(self)
    }
    
}

public final class CancellableBag {
    
    private let lock = UnfairLock()
    
    private var isCancelled = false
    private var cancellables = [Cancellable]()
    
    public init() {
        
    }
    
    deinit {
        self.cancel()
    }
    
    public func insert(_ cancellable: Cancellable) {
        self.lock.withLock {
            guard !self.isCancelled else {
                cancellable.cancel()
                return
            }
            self.cancellables.append(cancellable)
        }
    }
    
    private func cancel() {
        self.lock.withLock {
            self.isCancelled = true
            
            self.cancellables.removeAll {
                $0.cancel()
                return true
            }
        }
    }
    
}

/// Convenience
extension CancellableBag {
    
    public convenience init(cancelling cancellables: Cancellable...) {
        self.init()
        self.cancellables += cancellables
    }
    
    public convenience init(@CancellableBuilder builder: () -> [Cancellable]) {
        self.init(cancelling: builder())
    }
    
    public convenience init(cancelling cancellables: [Cancellable]) {
        self.init()
        self.cancellables += cancellables
    }
    
    public func insert(_ cancellables: Cancellable...) {
        self.insert(cancellables)
    }
    
    public func insert(@CancellableBuilder builder: () -> [Cancellable]) {
        self.insert(builder())
    }
    
    public func insert(_ cancellables: [Cancellable]) {
        self.lock.withLock {
            guard !self.isCancelled else {
                cancellables.forEach { $0.cancel() }
                return
            }
            self.cancellables += cancellables
        }
    }
    
    @resultBuilder
    public struct CancellableBuilder {
        
        public static func buildBlock(_ cancellables: Cancellable...) -> [Cancellable] {
            return cancellables
        }
        
    }
    
}
