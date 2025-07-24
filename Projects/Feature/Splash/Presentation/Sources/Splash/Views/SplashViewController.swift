//
//  SplashViewController.swift
//  Splash
//
//  Created by JunHyeok Lee on 7/21/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Lottie

import BasePresentation

public final class SplashViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let lottieAnimationView: LottieAnimationView = {
        let lottieView = LottieAnimationView(name: .splash)
        lottieView.loopMode = .loop
        lottieView.alpha = 0.3
        lottieView.animationSpeed = 0.5
        return lottieView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "F1 Manager"
        label.font = .f1(.bold, size: 22)
        label.textColor = .red
        return label
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: SplashReactor) -> SplashViewController {
        let viewController = SplashViewController()
        viewController.reactor = reactor
        return viewController
    }
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implremented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupLayoutConstraints()
        lottieAnimationView.play()
    }
    
    public func bind(reactor: SplashReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
    }
}

// MARK: - Bind
extension SplashViewController {
    private func bindAction(_ reactor: SplashReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SplashReactor) {
        
    }
}

// MARK: - Layout
extension SplashViewController {
    private func addSubviews() {
        view.addSubview(lottieAnimationView)
        view.addSubview(label)
    }
    
    private func setupLayoutConstraints() {
        lottieAnimationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.center.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
