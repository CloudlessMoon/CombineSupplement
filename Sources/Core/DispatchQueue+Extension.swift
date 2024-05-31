//
//  DispatchQueue+Extension.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation

fileprivate extension DispatchQueue {
    
    static let mainKey: DispatchSpecificKey<UUID> = {
        let key = DispatchSpecificKey<UUID>()
        DispatchQueue.main.setSpecific(key: key, value: UUID())
        return key
    }()
    
}

extension CombineWrapper where Base: DispatchQueue {
    
    internal static var isMain: Bool {
        return Base.getSpecific(key: Base.mainKey) != nil
    }
    
}
