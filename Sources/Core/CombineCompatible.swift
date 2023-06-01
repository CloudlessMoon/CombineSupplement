//
//  CombineCompatible.swift
//  CombineSupplement
//
//  Created by jiasong on 2023/6/1.
//

import Foundation

public struct CombineWrapper<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
    
}

public protocol CombineCompatible {}

extension CombineCompatible {
    
    public static var combine: CombineWrapper<Self>.Type {
        get { CombineWrapper<Self>.self }
        set { }
    }
    
    public var combine: CombineWrapper<Self> {
        get { CombineWrapper(self) }
        set { }
    }
    
}

public protocol CombineCompatibleObject: AnyObject {}

extension CombineCompatibleObject {
    
    public static var combine: CombineWrapper<Self>.Type {
        get { CombineWrapper<Self>.self }
        set { }
    }
    
    public var combine: CombineWrapper<Self> {
        get { CombineWrapper(self) }
        set { }
    }
    
}

extension NSObject: CombineCompatibleObject {}
