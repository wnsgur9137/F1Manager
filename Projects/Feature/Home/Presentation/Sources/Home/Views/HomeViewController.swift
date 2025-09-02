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
import RxDataSources
import SnapKit

import BasePresentation

public final class HomeViewController: UIViewController, View {
    
    // MARK: - UI Instances
    
    private let navigationBar = NavigationBar(.nonButton)
    
    private lazy var driversCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DriverCollectionViewCell.self, forCellWithReuseIdentifier: DriverCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var racesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RaceCollectionViewCell.self, forCellWithReuseIdentifier: RaceCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let driverSectionHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let driversLabel: UILabel = {
        let label = UILabel()
        label.text = "Drivers"
        label.font = .f1(.bold, size: 24)
        label.textColor = .label
        return label
    }()
    
    private let seeAllDriversButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .f1(.regular, size: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let raceSectionHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let racesLabel: UILabel = {
        let label = UILabel()
        label.text = "Races"
        label.font = .f1(.bold, size: 24)
        label.textColor = .label
        return label
    }()
    
    private let seeAllRacesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .f1(.regular, size: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    // MARK: - Properties
    
    private lazy var driversDataSource = makeDataSource(cellIdentifier: DriverCollectionViewCell.identifier) { (cell: DriverCollectionViewCell, driver: DriverModel) in
        cell.configure(with: driver)
    }
    
    private lazy var racesDataSource = makeDataSource(cellIdentifier: RaceCollectionViewCell.identifier) { (cell: RaceCollectionViewCell, race: RaceModel) in
        cell.configure(with: race)
    }
    
    public var disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    public static func create(with reactor: HomeReactor) -> HomeViewController {
        let viewController = HomeViewController()
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
        setupButtons()
        setupCollectionViews()
        addSubviews()
        setupLayoutConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        navigationBar.setTitle("F1 Manager")
    }
    
    private func setupButtons() {
        seeAllDriversButton.addTarget(self, action: #selector(seeAllDriversButtonTapped), for: .touchUpInside)
        seeAllRacesButton.addTarget(self, action: #selector(seeAllRacesButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionViews() {
        driversCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        racesCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    @objc private func seeAllDriversButtonTapped() {
        reactor?.action.onNext(.navigateToDriverList)
    }
    
    @objc private func seeAllRacesButtonTapped() {
        reactor?.action.onNext(.navigateToRaceList)
    }
    
    public func bind(reactor: HomeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func makeDataSource<Model, Cell: UICollectionViewCell>(
        cellIdentifier: String,
        configureCell: @escaping (Cell, Model) -> Void
    ) -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, Model>> {
        return .init(configureCell: { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? Cell else {
                assertionFailure("셀을 dequeue하거나 타입 캐스팅하는 데 실패했습니다: \(cellIdentifier)")
                return UICollectionViewCell()
            }
            configureCell(cell, item)
            return cell
        })
    }
}

// MARK: - Bind
extension HomeViewController {
    private func bindAction(_ reactor: HomeReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeReactor) {
        reactor.pulse(\.$drivers)
            .compactMap { $0 }
            .map { drivers in
                let sortedDrivers = Array(drivers
                    .sorted { (first, second) in
                        guard let firstPosition = first.standingPosition,
                              let secondPosition = second.standingPosition else {
                            return false
                        }
                        return firstPosition < secondPosition
                    }
                    .prefix(5))
                return [SectionModel(model: "drivers", items: sortedDrivers)]
            }
            .bind(to: driversCollectionView.rx.items(dataSource: driversDataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$races)
            .compactMap { $0 }
            .map { races in
                let upcomingRaces = Array(self.getUpcomingRaces(from: races).prefix(5))
                return [SectionModel(model: "races", items: upcomingRaces)]
            }
            .bind(to: racesCollectionView.rx.items(dataSource: racesDataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .bind(onNext: { error in
                
            })
            .disposed(by: disposeBag)
        
        driversCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let driver = self?.driversDataSource[indexPath] else { return }
                self?.reactor?.action.onNext(.driverSelected(driver))
            })
            .disposed(by: disposeBag)
        
        racesCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let race = self?.racesDataSource[indexPath] else { return }
                self?.reactor?.action.onNext(.raceSelected(race))
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == driversCollectionView {
            return CGSize(width: 140, height: 200)
        } else if collectionView == racesCollectionView {
            return CGSize(width: 180, height: 160)
        }
        return .zero
    }
}

// MARK: - Layout
extension HomeViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(driverSectionHeaderView)
        view.addSubview(driversCollectionView)
        view.addSubview(raceSectionHeaderView)
        view.addSubview(racesCollectionView)
        
        [
            driversLabel,
            seeAllDriversButton
        ].forEach {
            driverSectionHeaderView.addSubview($0)
        }
        
        [
            racesLabel,
            seeAllRacesButton
        ].forEach {
            raceSectionHeaderView.addSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        driverSectionHeaderView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        driversLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        seeAllDriversButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        driversCollectionView.snp.makeConstraints {
            $0.top.equalTo(driverSectionHeaderView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(200)
        }
        
        raceSectionHeaderView.snp.makeConstraints {
            $0.top.equalTo(driversCollectionView.snp.bottom).offset(32)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        racesLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        seeAllRacesButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        racesCollectionView.snp.makeConstraints {
            $0.top.equalTo(raceSectionHeaderView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(160)
        }
    }
    
    private func getUpcomingRaces(from races: [RaceModel]) -> [RaceModel] {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return races
            .compactMap { race -> (RaceModel, Date)? in
                guard let raceDate = dateFormatter.date(from: race.date) else { return nil }
                return (race, raceDate)
            }
            .filter { _, raceDate in
                // 현재 날짜와 같거나 미래의 레이스만 필터링
                Calendar.current.compare(raceDate, to: currentDate, toGranularity: .day) != .orderedAscending
            }
            .sorted { $0.1 < $1.1 } // 날짜순으로 정렬
            .map { $0.0 } // RaceModel만 반환
    }
}
