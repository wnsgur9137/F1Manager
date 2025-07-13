//
//  DIContainer.swift
//  BasePresentation
//
//  Created by JUNHYEOK LEE on 7/13/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation

open class DIContainer {
    
    private let sharedInstanceLock = NSRecursiveLock()
    private var sharedInstances = [String: Any]()
    
    public final func shared<T>(
        __function: String = #function,
        _ factory: () -> T
    ) -> T {
        sharedInstanceLock.lock()
        defer {
            sharedInstanceLock.unlock()
        }
        if let instance = (sharedInstances[__function] as? T?) ?? nil {
            return instance
        }
        let instance = factory()
        sharedInstances[__function] = instance
        return instance
    }
    
    public init() { }
    
    deinit {
#if DEBUG
        print("\(type(of: self)) deinit")
#endif
    }
}
