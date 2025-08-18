//
//  DriverListViewController.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/17/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

import BasePresentation

public final class DriverListViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let navigationBar = NavigationBar(.popButton)
    
    private let driversTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: DriverListAdapter?
    
    // MARK: - Life cycle
    
    public static func create(with reactor: DriverListReactor) -> DriverListViewController {
        let viewController = DriverListViewController()
        viewController.reactor = reactor
        return viewController
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
        setupUI()
        setupNavigationBar()
        addSubviews()
        setupLayoutConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "All Drivers"
    }
    
    private func setupNavigationBar() {
        navigationBar.setTitle("All Drivers")
    }
    
    public func bind(reactor: DriverListReactor) {
        bindAction(reactor)
        bindState(reactor)
        setupAdapter(with: reactor)
    }
    
    private func setupAdapter(with reactor: DriverListReactor) {
        let adapter = DriverListAdapter(
            driversTableView: driversTableView,
            dataSource: reactor,
            delegate: self
        )
        self.adapter = adapter
    }
}

// MARK: - Bind
extension DriverListViewController {
    private func bindAction(_ reactor: DriverListReactor) {
        rx.viewDidLoad
            .map { DriverListReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.didTapBackButton
            .map { DriverListReactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: DriverListReactor) {
        reactor.pulse(\.$driversDidUpdate)
            .compactMap { $0 }
            .bind(onNext: { [weak self] _ in
                self?.driversTableView.reloadData()
                self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .compactMap { $0 }
            .bind(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .bind(onNext: { [weak self] error in
                self?.showErrorAlert(error: error)
                self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Layout
extension DriverListViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(driversTableView)
        view.addSubview(loadingIndicator)
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        driversTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - DriverListDelegate
extension DriverListViewController: DriverListDelegate {
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        reactor?.action.onNext(.driverSelectedAt(indexPath))
    }
}
