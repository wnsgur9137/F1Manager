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
    
    private enum Filter: CaseIterable {
        case allRaces
        case upcoming
        case completed
        
        func title() -> String {
            switch self {
            case .allRaces:
                return "All Races"
            case .upcoming:
                return "Upcoming"
            case .completed:
                return "Completed"
            }
        }
    }
    
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
    
    private let filterSegmentedControl: UISegmentedControl = {
        let items = Filter.allCases.map { $0.title() }
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 1 // Upcoming이 기본값
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
        return segmentedControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RaceListTableViewCell.self, forCellReuseIdentifier: RaceListTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
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
    
    private var allRaces: [RaceModel] = []
    private var filteredRaces: [RaceModel] = []
    private var currentFilter: RaceFilter = .upcoming
    
    public var disposeBag = DisposeBag()
    
    private enum RaceFilter: Int, CaseIterable {
        case all = 0
        case upcoming = 1
        case completed = 2
    }
    
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
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func setupNavigationBar() {
        navigationBar.setTitle("Race Calendar")
    }
    
    private func setupActions() {
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
    }
    
    @objc private func filterChanged(_ sender: UISegmentedControl) {
        guard let filter = RaceFilter(rawValue: sender.selectedSegmentIndex) else { return }
        currentFilter = filter
        applyFilter()
    }
    
    public func bind(reactor: RaceListReactor) {
        bindAction(reactor)
        bindState(reactor)
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
        reactor.pulse(\.$races)
            .compactMap { $0 }
            .bind(onNext: { [weak self] races in
                self?.allRaces = races
                self?.applyFilter()
                self?.updateRaceCount()
                self?.hideLoading()
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

// MARK: - Filter Logic
extension RaceListViewController {
    private func applyFilter() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch currentFilter {
        case .all:
            filteredRaces = allRaces
        case .upcoming:
            filteredRaces = allRaces.filter { race in
                guard let raceDate = dateFormatter.date(from: race.date) else { return false }
                return Calendar.current.compare(raceDate, to: currentDate, toGranularity: .day) != .orderedAscending
            }
        case .completed:
            filteredRaces = allRaces.filter { race in
                guard let raceDate = dateFormatter.date(from: race.date) else { return false }
                return Calendar.current.compare(raceDate, to: currentDate, toGranularity: .day) == .orderedAscending
            }
        }
        
        tableView.reloadData()
    }
    
    private func updateRaceCount() {
        let totalRaces = allRaces.count
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

// MARK: - UITableViewDataSource
extension RaceListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRaces.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RaceListTableViewCell.identifier, for: indexPath) as? RaceListTableViewCell else {
            return UITableViewCell()
        }
        
        let race = filteredRaces[indexPath.row]
        cell.configure(with: race)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RaceListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRace = filteredRaces[indexPath.row]
        reactor?.action.onNext(.raceSelected(selectedRace))
    }
}

// MARK: - Layout
extension RaceListViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(headerView)
        view.addSubview(tableView)
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
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
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
