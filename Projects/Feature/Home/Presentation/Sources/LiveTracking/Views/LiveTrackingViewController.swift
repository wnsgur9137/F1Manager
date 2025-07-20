//
//  LiveTrackingViewController.swift
//  HomePresentation
//
//  Created by JUNHYEOK LEE on 7/20/25.
//  Copyright © 2025 com.junhyeok.F1Manager. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

import BasePresentation

public final class LiveTrackingViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let navigationBar = NavigationBar(.popButton)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let sessionInfoView: SessionInfoView = {
        let view = SessionInfoView()
        return view
    }()
    
    private let minimapView: MinimapView = {
        let view = MinimapView()
        return view
    }()
    
    private let liveDataView: LiveDataView = {
        let view = LiveDataView()
        return view
    }()
    
    private let driverSelectionView: DriverSelectionView = {
        let view = DriverSelectionView()
        return view
    }()
    
    private let playbackControlView: PlaybackControlView = {
        let view = PlaybackControlView()
        return view
    }()
    
    // MARK: - Properties
    
    public var disposeBag = DisposeBag()
    private var timer: Timer?
    private var currentDataIndex = 0
    private var carDataArray: [CarDataModel] = []
    private var positionDataArray: [PositionModel] = []
    
    // MARK: - Life cycle
    
    public static func create(with reactor: LiveTrackingReactor) -> LiveTrackingViewController {
        let viewController = LiveTrackingViewController()
        viewController.hidesBottomBarWhenPushed = true
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
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlayback()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Live Tracking"
    }
    
    private func setupNavigationBar() {
        navigationBar.setTitle("Live Tracking")
    }
    
    public func bind(reactor: LiveTrackingReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension LiveTrackingViewController {
    private func bindAction(_ reactor: LiveTrackingReactor) {
        rx.viewDidLoad
            .map { LiveTrackingReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.didTapBackButton
            .map { LiveTrackingReactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        driverSelectionView.driverSelected
            .map { LiveTrackingReactor.Action.driverSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        playbackControlView.playButtonTapped
            .map { LiveTrackingReactor.Action.playbackToggled }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        playbackControlView.speedChanged
            .map { LiveTrackingReactor.Action.speedChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: LiveTrackingReactor) {
        reactor.pulse(\.$sessionData)
            .compactMap { $0 }
            .bind(onNext: { [weak self] session in
                self?.sessionInfoView.configure(with: session)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$carData)
            .compactMap { $0 }
            .bind(onNext: { [weak self] carData in
                self?.carDataArray = carData
                self?.updateMinimapData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$positionData)
            .compactMap { $0 }
            .bind(onNext: { [weak self] positionData in
                self?.positionDataArray = positionData
                self?.updateMinimapData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isPlaying)
            .compactMap { $0 }
            .bind(onNext: { [weak self] isPlaying in
                if isPlaying {
                    self?.startPlayback()
                } else {
                    self?.stopPlayback()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$selectedDriver)
            .compactMap { $0 }
            .bind(onNext: { [weak self] driverNumber in
                self?.driverSelectionView.selectDriver(driverNumber)
                self?.updateLiveDataForDriver(driverNumber)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension LiveTrackingViewController {
    private func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            sessionInfoView,
            minimapView,
            liveDataView,
            driverSelectionView,
            playbackControlView
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupLayoutConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        sessionInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
        
        minimapView.snp.makeConstraints {
            $0.top.equalTo(sessionInfoView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(250)
        }
        
        liveDataView.snp.makeConstraints {
            $0.top.equalTo(minimapView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }
        
        driverSelectionView.snp.makeConstraints {
            $0.top.equalTo(liveDataView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        playbackControlView.snp.makeConstraints {
            $0.top.equalTo(driverSelectionView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Playback Control
extension LiveTrackingViewController {
    private func startPlayback() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updatePlaybackFrame()
        }
    }
    
    private func stopPlayback() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updatePlaybackFrame() {
        guard currentDataIndex < carDataArray.count,
              currentDataIndex < positionDataArray.count else {
            stopPlayback()
            currentDataIndex = 0
            return
        }
        
        let carData = carDataArray[currentDataIndex]
        let positionData = positionDataArray[currentDataIndex]
        
        // 미니맵 업데이트
        let position = CGPoint(x: CGFloat(positionData.x), y: CGFloat(positionData.y))
        let displayCarData = CarData(
            speed: carData.speed,
            gear: carData.gear,
            isDrsActive: carData.drs == 1,
            brakePercentage: Double(carData.brake) / 100.0,
            throttlePercentage: Double(carData.throttle) / 100.0
        )
        
        minimapView.updateCarPosition(
            driverNumber: carData.driverNumber,
            position: position,
            carData: displayCarData
        )
        
        // 선택된 드라이버의 데이터 업데이트
        if let selectedDriver = reactor?.currentState.selectedDriver,
           carData.driverNumber == selectedDriver {
            liveDataView.updateData(displayCarData)
            liveDataView.updateThrottle(displayCarData.throttlePercentage)
            liveDataView.updateBrake(displayCarData.brakePercentage)
        }
        
        currentDataIndex += 1
    }
    
    private func updateMinimapData() {
        // 초기 트랙 이미지 설정 (실제 구현에서는 서킷별 이미지 로드)
        minimapView.setTrackImage(UIImage(systemName: "oval"))
    }
    
    private func updateLiveDataForDriver(_ driverNumber: Int) {
        // 현재 프레임의 해당 드라이버 데이터로 업데이트
        guard currentDataIndex < carDataArray.count else { return }
        
        if let carData = carDataArray.first(where: { $0.driverNumber == driverNumber }) {
            let displayCarData = CarData(
                speed: carData.speed,
                gear: carData.gear,
                isDrsActive: carData.drs == 1,
                brakePercentage: Double(carData.brake) / 100.0,
                throttlePercentage: Double(carData.throttle) / 100.0
            )
            
            liveDataView.updateData(displayCarData)
            liveDataView.updateThrottle(displayCarData.throttlePercentage)
            liveDataView.updateBrake(displayCarData.brakePercentage)
        }
    }
}

// MARK: - Temporary Model Placeholders
// These would be replaced with actual models from Domain layer

public struct CarDataModel {
    let brake: Int
    let date: String
    let driverNumber: Int
    let drs: Int
    let gear: Int
    let meetingKey: Int
    let rpm: Int
    let sessionKey: Int
    let speed: Int
    let throttle: Int
}

public struct PositionModel {
    let date: String
    let driverNumber: Int
    let meetingKey: Int
    let position: Int
    let sessionKey: Int
    let x: Double
    let y: Double
    let z: Double
}

public struct SessionModel {
    let circuitShortName: String
    let sessionName: String
    let sessionType: String
    let year: Int
}

// Placeholder Reactor
public final class LiveTrackingReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case backButtonTapped
        case driverSelected(Int)
        case playbackToggled
        case speedChanged(Double)
    }
    
    public enum Mutation {
        case setSessionData(SessionModel?)
        case setCarData([CarDataModel])
        case setPositionData([PositionModel])
        case setIsPlaying(Bool)
        case setSelectedDriver(Int?)
    }
    
    public struct State {
        @Pulse var sessionData: SessionModel?
        @Pulse var carData: [CarDataModel] = []
        @Pulse var positionData: [PositionModel] = []
        @Pulse var isPlaying: Bool = false
        @Pulse var selectedDriver: Int?
    }
    
    public let initialState = State()
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return loadInitialData()
        case .backButtonTapped:
            return .empty()
        case .driverSelected(let driverNumber):
            return .just(.setSelectedDriver(driverNumber))
        case .playbackToggled:
            return .just(.setIsPlaying(!currentState.isPlaying))
        case .speedChanged:
            return .empty()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSessionData(let session):
            newState.sessionData = session
        case .setCarData(let carData):
            newState.carData = carData
        case .setPositionData(let positionData):
            newState.positionData = positionData
        case .setIsPlaying(let isPlaying):
            newState.isPlaying = isPlaying
        case .setSelectedDriver(let driverNumber):
            newState.selectedDriver = driverNumber
        }
        return newState
    }
    
    private func loadInitialData() -> Observable<Mutation> {
        // Placeholder - 실제 구현에서는 OpenF1Service 사용
        let sessionData = SessionModel(
            circuitShortName: "Silverstone",
            sessionName: "British Grand Prix",
            sessionType: "Race",
            year: 2024
        )
        
        return .concat([
            .just(.setSessionData(sessionData)),
            .just(.setCarData([])),
            .just(.setPositionData([]))
        ])
    }
}
