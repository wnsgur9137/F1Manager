//
//  RaceListViewController.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/12/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

import BasePresentation

public final class RaceListViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let navigationBar = NavigationBar(.popButton)
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.text = "2025 SEASON"
        label.font = .f1(.bold, size: 28)
        label.textColor = .systemRed
        return label
    }()
    
    private let raceCountLabel: UILabel = {
        let label = UILabel()
        label.font = .f1(.regular, size: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var filterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }()
    
    private let raceListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tableView
    }()
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemRed
        return indicator
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading Races..."
        label.font = .f1(.regular, size: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var adapter: RaceListAdapter?
    
    // MARK: - Life cycle
    
    public static func create(with reactor: RaceListReactor) -> RaceListViewController {
        let viewController = RaceListViewController()
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
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func setupNavigationBar() {
        navigationBar.setTitle("Race Calendar")
    }
    
    public func bind(reactor: RaceListReactor) {
        bindAction(reactor)
        bindState(reactor)
        setupAdapter(with: reactor)
    }
    
    private func setupAdapter(with reactor: RaceListReactor) {
        let adapter = RaceListAdapter(
            raceListTableView: raceListTableView,
            dataSource: reactor,
            delegate: self
        )
        self.adapter = adapter
    }
    
    private func setupFilterSegmentedControl(_ filters: [RaceListReactor.RaceFilter]) {
        // 기존 segmentedControl 제거
        filterSegmentedControl.removeFromSuperview()
        
        let items = filters.map { $0.title() }
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.backgroundColor = .systemGray6
        segmentedControl.selectedSegmentTintColor = .systemRed
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.f1(.bold, size: 14)
        ], for: .selected)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.f1(.regular, size: 14)
        ], for: .normal)
        
        self.filterSegmentedControl = segmentedControl
        
        // 뷰 계층에 다시 추가
        headerView.addSubview(filterSegmentedControl)
        
        // 제약조건 재설정
        filterSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(raceCountLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        if let reactor = reactor {
            filterSegmentedControl.rx.selectedSegmentIndex
                .map { Reactor.Action.filterChanged($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - Bind
extension RaceListViewController {
    private func bindAction(_ reactor: RaceListReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.didTapBackButton
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: RaceListReactor) {
        reactor.pulse(\.$raceFilters)
            .compactMap { $0 }
            .bind(onNext: { [weak self] filters in
                self?.setupFilterSegmentedControl(filters)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$currentRaceFilter)
            .bind(onNext: { [weak self] filter in
                self?.filterSegmentedControl.selectedSegmentIndex = filter.rawValue
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$racesDidUpdate)
            .compactMap { $0 }
            .bind(onNext: { [weak self] in
                self?.updateRaceCount()
                self?.hideLoading()
                self?.raceListTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .bind(onNext: { [weak self] error in
                self?.hideLoading()
                // Handle error
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper Methods
extension RaceListViewController {
    private func updateRaceCount() {
        guard let reactor = reactor else { return }
        let totalRaces = reactor.numberOfRows(in: 0)
        raceCountLabel.text = "\(totalRaces) Races"
    }
    
    private func showLoading() {
        loadingView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
        activityIndicator.stopAnimating()
    }
}

// MARK: - RaceListDelegate
extension RaceListViewController: RaceListDelegate {
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        reactor?.action.onNext(.raceSelectedAt(indexPath))
    }
}

// MARK: - Layout
extension RaceListViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(headerView)
        view.addSubview(raceListTableView)
        view.addSubview(loadingView)
        
        headerView.addSubview(seasonLabel)
        headerView.addSubview(raceCountLabel)
        headerView.addSubview(filterSegmentedControl)
        
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        seasonLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        raceCountLabel.snp.makeConstraints {
            $0.top.equalTo(seasonLabel.snp.bottom).offset(4)
            $0.leading.equalTo(seasonLabel)
        }
        
        filterSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(raceCountLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        raceListTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        loadingLabel.snp.makeConstraints {
            $0.top.equalTo(activityIndicator.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}
