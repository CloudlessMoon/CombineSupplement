//
//  CancellableBag.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/6/28.
//

import Foundation
import Combine
import ThreadSafe

public final class CancellableBag {
    
    @resultBuilder
    public enum Builder {
        
        public static func buildBlock(_ cancellables: Cancellable...) -> [Cancellable] {
            return cancellables
        }
        
    }
    
    private let lock = UnfairLock()
    
    private var isCancelled = false
    private var cancellables = [Cancellable]()
    
    public init() {
        
    }
    
    deinit {
        self.cancel()
    }
    
}

extension CancellableBag {
    
    public convenience init(cancelling cancellables: Cancellable...) {
        self.init(cancelling: cancellables)
    }
    
    public convenience init(@Builder builder: () -> [Cancellable]) {
        self.init(cancelling: builder())
    }
    
    public convenience init(cancelling cancellables: [Cancellable]) {
        self.init()
        self.cancellables += cancellables
    }
    
}

extension CancellableBag {
    
    public func insert(_ cancellables: Cancellable...) {
        self.insert(cancellables)
    }
    
    public func insert(@Builder builder: () -> [Cancellable]) {
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
    
    public func insert(_ cancellable: Cancellable) {
        self.lock.withLock {
            guard !self.isCancelled else {
                cancellable.cancel()
                return
            }
            self.cancellables.append(cancellable)
        }
    }
    
}

extension CancellableBag {
    
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
