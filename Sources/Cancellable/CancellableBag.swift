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
    
    public init(cancellables: Cancellable...) {
        self.cancellables += cancellables
    }
    
    public init(cancellables: [Cancellable]) {
        self.cancellables += cancellables
    }
    
    public init(@Builder builder: () -> [Cancellable]) {
        self.cancellables += builder()
    }
    
    deinit {
        self.cancel()
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
        let current: [Cancellable]? = self.lock.withLock {
            guard !self.isCancelled else {
                return cancellables
            }
            self.cancellables += cancellables
            return nil
        }
        current?.forEach {
            $0.cancel()
        }
    }
    
    public func insert(_ cancellable: Cancellable) {
        let current: Cancellable? = self.lock.withLock {
            guard !self.isCancelled else {
                return cancellable
            }
            self.cancellables.append(cancellable)
            return nil
        }
        current?.cancel()
    }
    
    public func cancel() {
        let current: [Cancellable]? = self.lock.withLock {
            let cancellables = self.cancellables
            guard !self.isCancelled || !cancellables.isEmpty else {
                return nil
            }
            self.isCancelled = true
            self.cancellables.removeAll()
            return cancellables
        }
        current?.forEach {
            $0.cancel()
        }
    }
    
}
