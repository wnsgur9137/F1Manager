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

public final class HomeViewController: UIViewController {
    
    // MARK: - UI Instances
    
    // MARK: - Properties
    
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
        print("🚨\(#function)")
    }
}

// MARK: - Layout
extension HomeViewController {
    
}
