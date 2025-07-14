//
//  HomeReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 7/15/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import ReactorKit

public struct HomeFlowAction {
    
}

public final class HomeReactor: Reactor {
    
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: HomeFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: HomeFlowAction) {
        self.flowAction = flowAction
    }
    
}

// MARK: - React
extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    public func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        switch mutation {
            
        }
        return state
    }
}

// MARK: - FlowAction
extension HomeReactor {
    
}
