# F1Manager iOS 프로젝트 스타일 가이드

## 개요

이 스타일 가이드는 F1Manager iOS 애플리케이션의 코드 일관성, 가독성, 유지보수성을 보장하기 위한 가이드라인입니다. 
모든 개발자는 이 가이드라인을 준수하여 Clean Architecture 기반의 모듈화된 코드를 작성해야 합니다.

## 핵심 원칙

1. **가독성**: 코드는 자명해야 하며, 의도가 명확히 드러나야 합니다
2. **일관성**: 프로젝트 전반에 걸쳐 일관된 코딩 스타일을 유지합니다
3. **모듈화**: Clean Architecture 원칙에 따라 레이어를 분리합니다
4. **테스트 가능성**: 모든 비즈니스 로직은 테스트 가능하도록 작성합니다
5. **성능**: 메모리 효율성과 배터리 소모를 고려합니다

## 프로젝트 아키텍처

### Clean Architecture 레이어
- **Domain**: 비즈니스 로직과 엔티티 (BaseDomin, *Domain 모듈)
- **Data**: 데이터 접근 및 Repository 구현 (BaseData, *Data 모듈)
- **Presentation**: UI 및 화면 로직 (BasePresentation, *Presentation 모듈)

### 의존성 방향
```
Presentation → Domain ← Data
```
- Presentation과 Data는 Domain에만 의존
- Domain은 다른 레이어에 의존하지 않음

## Swift 코딩 컨벤션

### 네이밍 규칙

#### 클래스 및 구조체 (PascalCase)
```swift
// ✅ 올바른 예시
class UserRepository { }
struct DriverModel { }
protocol NetworkManagerType { }

// ❌ 잘못된 예시
class userRepository { }
struct driver_model { }
```

#### 변수 및 함수 (camelCase)
```swift
// ✅ 올바른 예시
let defaultTimeout: TimeInterval = 30.0
func getUserData() -> User { }
var isLoading: Bool = false

// ❌ 잘못된 예시
let default_timeout: TimeInterval = 30.0
func get_user_data() -> User { }
```

#### 상수 (camelCase)
```swift
// ✅ 올바른 예시
private let apiBaseURL = "https://api.formula1.com"
static let defaultPageSize = 20

// ❌ 잘못된 예시
private let API_BASE_URL = "https://api.formula1.com"
static let DEFAULT_PAGE_SIZE = 20
```

#### 열거형 (PascalCase, case는 camelCase)
```swift
// ✅ 올바른 예시
enum NetworkError: Error {
    case noInternetConnection
    case serverError(String)
    case invalidResponse
}

// ❌ 잘못된 예시
enum NetworkError: Error {
    case NoInternetConnection
    case server_error(String)
}
```

### 들여쓰기 및 공백
- 들여쓰기: 4개의 스페이스 사용 (탭 금지)
- 함수 매개변수가 길 경우 줄바꿈:
```swift
// ✅ 올바른 예시
func fetchDriverData(
    driverId: String,
    season: Int,
    completion: @escaping (Result<Driver, NetworkError>) -> Void
) {
    // 구현
}
```

### 타입 어노테이션
```swift
// ✅ 올바른 예시 - 명시적 타입 지정
let drivers: [Driver] = []
var isLoading: Bool = false

// ✅ 타입 추론 가능한 경우
let driverName = "Lewis Hamilton"
```

### 옵셔널 처리
```swift
// ✅ Guard 문 사용 권장
guard let driver = selectedDriver else {
    return
}

// ✅ Nil 병합 연산자 활용
let driverName = driver?.name ?? "Unknown Driver"

// ❌ 강제 언래핑 금지
let name = driver!.name
```

## 파일 구조 및 모듈화

### 디렉토리 구조
```
Feature/
├── Home/
│   ├── Data/           # Repository 구현, DTO
│   ├── Domain/         # UseCase, Entity, Repository 인터페이스
│   ├── Presentation/   # ViewController, Reactor, ViewModel
│   └── Home/           # Coordinator, DI Container
```

### 파일 네이밍
- 파일명은 포함된 주요 타입명과 일치
- 접미사로 역할 구분: `*Repository.swift`, `*UseCase.swift`, `*Reactor.swift`

```swift
// ✅ 올바른 예시
DriverRepository.swift          // protocol DriverRepository
DefaultDriverRepository.swift   // class DefaultDriverRepository
DriverUseCase.swift            // protocol DriverUseCase
```

## 아키텍처 패턴

### DI Container 사용
```swift
// ✅ 올바른 예시
protocol DriverUseCaseType {
    func fetchDrivers() -> Observable<[Driver]>
}

class DefaultDriverUseCase: DriverUseCaseType {
    private let repository: DriverRepositoryType
    
    init(repository: DriverRepositoryType) {
        self.repository = repository
    }
}
```

### Coordinator 패턴
```swift
// ✅ 올바른 예시
protocol HomeCoordinatorType {
    func start()
    func showDriverDetail(_ driver: Driver)
}

class DefaultHomeCoordinator: HomeCoordinatorType {
    private weak var navigationController: UINavigationController?
    private let diContainer: HomeDIContainer
    
    init(navigationController: UINavigationController?,
         diContainer: HomeDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
}
```

### ReactorKit 패턴
```swift
// ✅ 올바른 예시
class HomeReactor: Reactor {
    enum Action {
        case viewDidLoad
        case refreshDrivers
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDrivers([DriverModel])
    }
    
    struct State {
        var isLoading: Bool = false
        var drivers: [DriverModel] = []
    }
}
```

## 네트워킹

### NetworkType 프로토콜 사용
```swift
// ✅ 올바른 예시
enum DriverAPI: NetworkType {
    case getDrivers(season: Int)
    case getDriverDetail(id: String)
    
    var path: String {
        switch self {
        case .getDrivers:
            return "/drivers"
        case .getDriverDetail(let id):
            return "/drivers/\(id)"
        }
    }
}
```

### 에러 처리
```swift
// ✅ 올바른 예시
func fetchDrivers() -> Observable<[Driver]> {
    return networkManager.request(DriverAPI.getDrivers(season: 2024))
        .map { response in
            return response.data.compactMap { Driver(from: $0) }
        }
        .catch { error in
            Logger.error("Failed to fetch drivers: \(error)")
            return Observable.error(NetworkError.fetchFailed)
        }
}
```

## 메모리 관리

### 순환 참조 방지
```swift
// ✅ 올바른 예시
class HomeViewController: UIViewController {
    private let reactor: HomeReactor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor.action.onNext(.viewDidLoad)
        
        reactor.state
            .map { $0.drivers }
            .bind(to: tableView.rx.items) { [weak self] tableView, index, driver in
                // weak self 사용
                return self?.configureCell(driver: driver) ?? UITableViewCell()
            }
            .disposed(by: disposeBag)
    }
}
```

## 주석 및 문서화

### 함수 문서화
```swift
// ✅ 올바른 예시
/// 특정 시즌의 드라이버 목록을 가져옵니다
/// - Parameter season: 조회할 시즌 (예: 2024)
/// - Returns: Driver 배열을 포함한 Observable
func fetchDrivers(season: Int) -> Observable<[Driver]> {
    // 구현
}
```

### 코드 주석
```swift
// ✅ 올바른 예시 - 비즈니스 로직 설명
// F1 규정에 따라 한 시즌당 최대 20명의 드라이버만 참가 가능
let maxDriversPerSeason = 20

// ❌ 잘못된 예시 - 자명한 코드 설명
// 드라이버 배열을 생성
let drivers: [Driver] = []
```

## 테스트 가이드라인

### 단위 테스트
```swift
// ✅ 올바른 예시
class DefaultDriverUseCaseTests: XCTestCase {
    var sut: DefaultDriverUseCase!
    var mockRepository: MockDriverRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockDriverRepository()
        sut = DefaultDriverUseCase(repository: mockRepository)
    }
    
    func test_fetchDrivers_성공시_드라이버목록반환() {
        // Given
        let expectedDrivers = [Driver.mock()]
        mockRepository.driversToReturn = expectedDrivers
        
        // When
        let result = sut.fetchDrivers().toBlocking().materialize()
        
        // Then
        switch result {
        case .completed(let elements):
            XCTAssertEqual(elements.first, expectedDrivers)
        case .failed:
            XCTFail("예상하지 못한 실패")
        }
    }
}
```

## 로깅

### Logger 사용
```swift
// ✅ 올바른 예시
import NetworkInfra

class DefaultDriverRepository {
    func fetchDrivers() -> Observable<[Driver]> {
        Logger.info("드라이버 목록 조회 시작")
        
        return networkManager.request(DriverAPI.getDrivers)
            .do(onNext: { _ in
                Logger.info("드라이버 목록 조회 완료")
            })
            .catch { error in
                Logger.error("드라이버 목록 조회 실패: \(error)")
                return Observable.error(error)
            }
    }
}
```

## 금지 사항

1. **강제 언래핑**: `!` 연산자 사용 금지
2. **하드코딩된 문자열**: Localizable.strings 사용 필수
3. **메인 스레드 외 UI 업데이트**: DispatchQueue.main 사용 필수
4. **레이어 간 부적절한 의존성**: Domain이 Presentation/Data에 의존 금지
5. **순환 참조**: weak/unowned 키워드 적절히 사용

## 권장 도구

- **코드 포맷터**: SwiftFormat
- **린터**: SwiftLint
- **의존성 관리**: Swift Package Manager (SPM)
- **프로젝트 관리**: Tuist

이 가이드라인을 따라 일관성 있고 유지보수 가능한 코드를 작성해주세요.