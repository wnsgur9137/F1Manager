# F1Manager Code Review Rules

## 자동화된 코드 리뷰 규칙

### 1. Clean Architecture 준수

#### 필수 체크사항
- [ ] Data Layer는 Domain Layer에만 의존
- [ ] Domain Layer는 다른 레이어에 의존하지 않음
- [ ] Presentation Layer는 Domain Layer에만 의존
- [ ] 순환 의존성 없음

#### 자동 검사 규칙
```yaml
architecture_rules:
  - name: "Data layer isolation"
    pattern: "Projects/Feature/*/Data/Sources/**/*.swift"
    forbidden_imports: ["*Presentation*"]
    severity: "critical"

  - name: "Domain layer independence"
    pattern: "Projects/Feature/*/Domain/Sources/**/*.swift"
    allowed_imports: ["Foundation", "BaseDomain"]
    severity: "critical"
```

### 2. Swift 네이밍 컨벤션

#### 자동 검사 패턴
```regex
# PascalCase for types
class_struct_pattern: "^[A-Z][a-zA-Z0-9]*$"

# camelCase for variables/functions
variable_function_pattern: "^[a-z][a-zA-Z0-9]*$"

# Enum cases camelCase
enum_case_pattern: "case [a-z][a-zA-Z0-9]*"
```

### 3. F1 디자인 시스템

#### UI 컴포넌트 체크
- [ ] F1 브랜딩 컬러 사용 (#E10600, #15151E 등)
- [ ] 일관된 그라데이션 적용
- [ ] 카드 기반 레이아웃 사용
- [ ] 그림자 효과 일관성

#### 금지 패턴
```swift
// ❌ 금지: forEach로 addSubview
subviews.forEach { containerView.addSubview($0) }

// ✅ 권장: 개별 addSubview
containerView.addSubview(titleLabel)
containerView.addSubview(subtitleLabel)
```

### 4. 다국어화

#### 필수 사항
- [ ] 하드코딩된 문자열 없음
- [ ] NSLocalizedString 사용
- [ ] Localizable.strings 업데이트

#### 자동 검사
```bash
# 하드코딩된 한글 문자열 체크
grep -r "\"[가-힣]\"" Projects/Feature/*/Presentation/Sources/

# NSLocalizedString 누락 체크
grep -r "\.text = \"" Projects/ | grep -v NSLocalizedString
```

### 5. 메모리 관리

#### Coordinator 패턴
```swift
// ✅ 권장: weak 참조
public weak var finishDelegate: CoordinatorFinishDelegate?
public weak var navigationController: UINavigationController?

// ❌ 금지: strong 참조
public var finishDelegate: CoordinatorFinishDelegate?
```

#### ReactorKit 패턴
```swift
// ✅ 권장: DisposeBag 사용
private let disposeBag = DisposeBag()

// 생명주기에서 적절한 dispose
deinit {
    // DisposeBag이 자동으로 dispose
}
```

### 6. Tuist 프로젝트 구조

#### 디렉토리 구조 검증
```
Projects/
├── Feature/
│   ├── {FeatureName}/
│   │   ├── Data/Project.swift
│   │   ├── Domain/Project.swift
│   │   ├── Presentation/Project.swift
│   │   └── {FeatureName}/Project.swift
```

#### 의존성 검증
```swift
// Data Layer
dependencies: [
    .Project.Base.Data,
    .Project.Feature.Domain.{FeatureName}Domain
]

// Domain Layer
dependencies: [
    .Project.Base.Domain
]

// Presentation Layer
dependencies: [
    .Project.Feature.Domain.{FeatureName}Domain,
    .Project.Base.Presentation,
    .Project.LibraryManager.ReactiveLibraries
]
```

### 7. 테스트 커버리지

#### 필수 테스트 대상
- [ ] UseCase 비즈니스 로직
- [ ] Repository 구현체
- [ ] Reactor 상태 변화
- [ ] Coordinator 네비게이션

#### 목표 커버리지
- Business Logic: 80% 이상
- Data Layer: 70% 이상
- Presentation Logic: 60% 이상

### 8. 성능 및 보안

#### 성능 체크포인트
- [ ] 이미지 로딩 최적화
- [ ] 네트워크 요청 캐싱
- [ ] 메모리 사용량 모니터링
- [ ] 배터리 효율성

#### 보안 체크포인트
- [ ] API 키 하드코딩 금지
- [ ] 민감한 데이터 로깅 금지
- [ ] 안전한 데이터 저장

### 9. 자동 리뷰 트리거

#### PR 생성시 자동 실행
- Swift 파일 변경 감지
- Tuist 설정 파일 변경 감지
- 의존성 변경 감지

#### 리뷰 수준 설정
```yaml
review_levels:
  basic: ["syntax", "naming", "imports"]
  standard: ["architecture", "patterns", "memory"]
  comprehensive: ["performance", "security", "testing"]
```

### 10. 예외 처리

#### 리뷰 제외 파일
- Generated 폴더
- Pods 폴더
- DerivedData 폴더
- .build 폴더

#### 특별 주석으로 규칙 제외
```swift
// swiftlint:disable:next force_cast
// codereview:ignore memory_management
```