//
//  MainScheduler.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/3/22.
//

import Foundation
import Combine
import ThreadSafe

public struct MainScheduler: Sendable {
    
    public static let instance = MainScheduler()
    public static let asyncInstance = MainScheduler(asynchronous: true)
    
    private let numberEnqueued = AtomicInt(0)
    
    private let isAsynchronous: Bool
    
    public init(asynchronous: Bool = false) {
        self.isAsynchronous = asynchronous
    }
    
}

extension MainScheduler: Scheduler {
    
    public typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
    public typealias SchedulerOptions = DispatchQueue.SchedulerOptions
    
    public var now: SchedulerTimeType {
        return DispatchQueue.main.now
    }
    
    public var minimumTolerance: SchedulerTimeType.Stride {
        return DispatchQueue.main.minimumTolerance
    }
    
    public func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        let previousNumberEnqueued = self.numberEnqueued.value
        self.numberEnqueued.increment()
        
        if !self.isAsynchronous && previousNumberEnqueued == 0 && DispatchQueue.threadSafe.isMain {
            action()
            
            self.numberEnqueued.decrement()
        } else {
            DispatchQueue.main.schedule(options: options) {
                action()
                
                self.numberEnqueued.decrement()
            }
        }
    }
    
    public func schedule(
        after date: SchedulerTimeType,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
    }
    
    public func schedule(
        after date: SchedulerTimeType,
        interval: SchedulerTimeType.Stride,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) -> Cancellable {
        DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
    }
    
}
