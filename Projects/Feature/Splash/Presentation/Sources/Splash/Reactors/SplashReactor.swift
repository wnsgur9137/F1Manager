//
//  SplashReactor.swift
//  Splash
//
//  Created by JunHyeok Lee on 7/21/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import BasePresentation

public struct SplashFlowAction {
    let showMainView: () -> Void
    
    public init(showMainView: @escaping () -> Void) {
        self.showMainView = showMainView
    }
}

enum SplashError: Error {
    
}

public final class SplashReactor: Reactor {
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case showMainView
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: SplashFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: SplashFlowAction) {
        self.flowAction = flowAction
    }
    
    private func handle(_ error: Error) -> SplashError? {
        guard let splashError = error as? SplashError? else { return nil }
        return splashError
    }
    
}

// MARK: - React
extension SplashReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.just(.showMainView)
                .delay(.milliseconds(1500), scheduler: MainScheduler.instance) // 스플래시 노출 시간
        }
    }
    
    public func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var state = state
        switch mutation {
        case .showMainView:
            flowAction.showMainView()
        }
        return state
    }
}
