//
//  MainScheduler.swift
//  CombineSupplement
//
//  Created by jiasong on 2024/3/22.
//

import Foundation
import Combine

public struct MainScheduler: Sendable {
    
    public static let instance = MainScheduler()
    public static let asyncInstance = MainScheduler(asynchronous: true)
    
    private static var detectionKey = DispatchSpecificKey<UInt8>()
    private static var detectionValue: UInt8 = 0
    
    private var canAsynchronous: Bool
    
    private init(asynchronous: Bool? = false) {
        self.canAsynchronous = asynchronous ?? false
        DispatchQueue.main.setSpecific(key: Self.detectionKey, value: Self.detectionValue)
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
        if !self.canAsynchronous && DispatchQueue.safeGetSpecific(key: Self.detectionKey) == Self.detectionValue {
            action()
        } else {
            DispatchQueue.main.schedule(options: options, action)
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
