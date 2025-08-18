# F1Manager 프로젝트 가이드라인

## 프로젝트 개요
F1Manager는 모듈화된 Clean Architecture를 기반으로 한 iOS 애플리케이션입니다.

## 아키텍처 구조
- **Clean Architecture**: Domain, Data, Presentation 레이어 분리
- **Tuist**: 모듈화된 프로젝트 관리
- **DI Container**: 의존성 주입 패턴
- **Coordinator Pattern**: 화면 전환 관리
- **ReactorKit**: 반응형 프로그래밍 (RxSwift 기반)

## 디렉토리 구조
```
Projects/
├── Application/         # 메인 앱 타겟
├── Base/               # 공통 기반 모듈
│   ├── BaseData/       # 공통 데이터 레이어
│   ├── BaseDomain/     # 공통 도메인 레이어
│   └── BasePresentation/ # 공통 프레젠테이션 레이어
├── Feature/            # 기능별 모듈
│   ├── Features/       # TabBar 관리
│   ├── Home/          # 홈 기능
│   ├── Onboarding/    # 온보딩 기능
│   └── Splash/        # 스플래시 기능
├── Infrastructure/     # 인프라 레이어
│   └── NetworkInfra/  # 네트워크 관리
├── InjectionManager/   # DI 컨테이너
└── LibraryManager/     # 외부 라이브러리 관리
```

## 코딩 컨벤션

### Swift 스타일 가이드
- **네이밍**: 
  - 클래스/구조체: PascalCase (예: `UserRepository`)
  - 변수/함수: camelCase (예: `getUserData`)
  - 상수: camelCase (예: `defaultTimeout`)
  - 열거형: PascalCase, case는 camelCase

### 파일 구조
- 각 기능별로 Data, Domain, Presentation 레이어 분리
- 각 레이어는 별도의 타겟으로 관리
- Tuist를 통한 프로젝트 생성 및 관리

### 의존성 관리
- DI Container를 통한 의존성 주입
- 프로토콜 기반 인터페이스 정의
- Mock 객체를 통한 테스트 지원

### 네트워킹
- NetworkInfra 모듈 사용
- Protocol-based networking (TargetType)
- Error handling with NetworkError
- Logger를 통한 로깅

## 코드 리뷰 가이드라인

### 체크 포인트
1. **아키텍처 준수**: Clean Architecture 원칙 준수 여부
2. **모듈 분리**: 적절한 레이어 분리 및 의존성 방향
3. **네이밍 컨벤션**: Swift 네이밍 가이드라인 준수
4. **테스트 코드**: 비즈니스 로직에 대한 테스트 작성
5. **메모리 관리**: 순환 참조 방지 (weak, unowned 적절한 사용)

### 금지 사항
- 직접적인 UI 업데이트 (메인 스레드 외)
- 하드코딩된 문자열 (Localizable.strings 사용)
- 강한 참조로 인한 메모리 누수
- 레이어 간 부적절한 의존성

## 테스트 가이드라인
- UseCase 레벨에서의 비즈니스 로직 테스트
- Repository 패턴을 통한 데이터 레이어 테스트
- Mock 객체를 활용한 단위 테스트
- UI 테스트는 주요 플로우에 대해서만 작성

## 라이브러리 사용 정책
- SPM(Swift Package Manager)을 통한 의존성 관리
- Tuist를 통한 라이브러리 모듈화
- 최신 버전 유지 및 보안 취약점 점검

## 성능 고려사항
- 이미지 로딩 최적화
- 네트워크 요청 캐싱
- 메모리 사용량 모니터링
- 배터리 효율성 고려