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

import BasePresentation

public final class SplashViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "F1 Manager"
        label.font = .f1(.wide, size: 38)
        label.textColor = .label
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
        addSubviews()
        setupLayoutConstraints()
    }
    
    public func bind(reactor: SplashReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Bind
extension SplashViewController {
    private func bindAction(_ reactor: SplashReactor) {
        
    }
    
    private func bindState(_ reactor: SplashReactor) {
        
    }
}

// MARK: - Layout
extension SplashViewController {
    private func addSubviews() {
        view.addSubview(label)
    }
    
    private func setupLayoutConstraints() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
