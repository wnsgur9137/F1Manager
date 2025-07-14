//
//  HomeViewController.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/13/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture

import BasePresentation

public final class HomeViewController: UIViewController {
    
    // MARK: - UI Instances
    
    private let navigationBar = NavigationBar()
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create() -> HomeViewController {
        return HomeViewController()
    }
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = .brown
        addSubviews()
        setupLayoutConstraints()
    }
}

// MARK: - Layout
extension HomeViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
