# Universal Code Review & PR Template Setup Guide

이 가이드는 다양한 플랫폼과 프로젝트에서 사용할 수 있는 범용적인 코드 리뷰 시스템 설정 방법을 설명합니다.

## 🚀 Quick Start

### 1. 파일 복사
프로젝트의 `.github` 디렉토리에 다음 파일들을 복사하세요:

```bash
.github/
├── universal-codereview-config.json
├── UNIVERSAL_PR_REVIEW_TEMPLATE.md
├── universal_pull_request_template.md
├── ISSUE_TEMPLATE/
│   ├── universal_bug_report.md
│   └── universal_feature_request.md
└── workflows/
    └── universal-code-review.yml
```

### 2. 환경 변수 설정
프로젝트 루트에 `.env` 파일을 생성하고 다음과 같이 설정하세요:

```bash
# 프로젝트 기본 정보
PROJECT_NAME="YourProjectName"
PROJECT_TYPE="ios-swift"  # 또는 android-kotlin, flutter-dart, react-native, web
ARCHITECTURE="clean-architecture"  # 또는 mvvm, viper, redux

# 아키텍처 패턴
PATTERN_1="coordinator"
PATTERN_2="mvvm"
PATTERN_3="di-container"

# 리뷰 가중치 (총합 100%)
ARCHITECTURE_WEIGHT=30
CODE_QUALITY_WEIGHT=25
UI_WEIGHT=20
MAINTAINABILITY_WEIGHT=15
SECURITY_WEIGHT=10

# 품질 기준
COVERAGE_THRESHOLD=70
REVIEW_DEPTH="comprehensive"  # basic, standard, comprehensive

# 기능 플래그
ENFORCE_LAYERS=true
DESIGN_CONSISTENCY=true
REQUIRE_LOCALIZATION=true
WEAK_DELEGATES=true
AVOID_RETAIN_CYCLES=true
```

### 3. GitHub Repository Variables 설정
GitHub Repository > Settings > Secrets and variables > Actions에서 다음 변수들을 설정하세요:

| Variable Name | Example Value | Description |
|---------------|---------------|-------------|
| `PROJECT_TYPE` | `ios-swift` | 프로젝트 주요 플랫폼 |
| `ARCHITECTURE` | `clean-architecture` | 사용하는 아키텍처 패턴 |
| `COVERAGE_THRESHOLD` | `70` | 테스트 커버리지 목표 |
| `REVIEW_DEPTH` | `comprehensive` | 리뷰 수준 |

## 📱 지원 플랫폼

### iOS (Swift)
```bash
PROJECT_TYPE="ios-swift"
ARCHITECTURE="clean-architecture"  # viper, mvvm
PATTERNS=["coordinator", "reactor-kit", "di-container"]
```

**특화 기능:**
- SwiftLint 통합
- Tuist 프로젝트 검증
- forEach addSubview 금지 패턴
- weak 참조 체크

### Android (Kotlin)
```bash
PROJECT_TYPE="android-kotlin"
ARCHITECTURE="mvvm"  # clean-architecture, mvp
PATTERNS=["repository", "viewmodel", "hilt"]
```

**특화 기능:**
- ktlint 통합
- Gradle 빌드 검증
- null safety 체크
- 코루틴 패턴 검증

### Flutter (Dart)
```bash
PROJECT_TYPE="flutter-dart"
ARCHITECTURE="bloc"  # provider, riverpod
PATTERNS=["bloc", "repository", "freezed"]
```

**특화 기능:**
- flutter analyze 통합
- pubspec.yaml 검증
- Widget 성능 체크
- 플랫폼별 조건부 코드 검증

### React Native
```bash
PROJECT_TYPE="react-native"
ARCHITECTURE="redux"  # context, mobx
PATTERNS=["hooks", "redux", "navigation"]
```

**특화 기능:**
- ESLint/Prettier 통합
- Metro bundler 검증
- 플랫폼별 코드 검증
- 성능 최적화 체크

### Web (React/Vue/Angular)
```bash
PROJECT_TYPE="web"
ARCHITECTURE="component-based"
PATTERNS=["hooks", "context", "routing"]
```

**특화 기능:**
- 웹팩/번들러 최적화 체크
- 접근성 검증
- SEO 최적화 확인
- 브라우저 호환성 체크

## 🔧 커스터마이징

### 1. 프로젝트별 규칙 추가

`universal-codereview-config.json`에서 프로젝트별 규칙을 추가하세요:

```json
{
  "reviewRules": {
    "customRules": {
      "yourProjectRule": "${YOUR_CUSTOM_RULE:-default_value}",
      "specificPatterns": ["pattern1", "pattern2"]
    }
  }
}
```

### 2. 플랫폼별 템플릿 확장

각 플랫폼별로 추가 체크리스트를 만들 수 있습니다:

```markdown
#### Your Platform Specific Checks
- [ ] Platform specific rule 1
- [ ] Platform specific rule 2
```

### 3. 워크플로우 커스터마이징

`.github/workflows/universal-code-review.yml`에서 추가 검증 단계를 추가하세요:

```yaml
- name: Custom Validation
  run: |
    echo "Running custom validations..."
    # 여기에 프로젝트별 검증 로직 추가
```

## 🎯 사용법

### 1. PR 생성
PR을 생성하면 자동으로 범용 템플릿이 적용됩니다. 해당하는 체크리스트만 작성하면 됩니다.

### 2. 자동 리뷰
CI/CD가 자동으로 실행되어 다음을 수행합니다:
- 프로젝트 타입 자동 감지
- 플랫폼별 코드 품질 검사
- 아키텍처 규칙 검증
- 보안 스캔
- 의존성 체크

### 3. 수동 리뷰
리뷰어는 `UNIVERSAL_PR_REVIEW_TEMPLATE.md`를 참고하여 일관된 리뷰를 작성할 수 있습니다.

## 📊 품질 메트릭

### 기본 평가 기준
| 카테고리 | 기본 가중치 | 평가 항목 |
|----------|-------------|-----------|
| Architecture | 30% | 레이어 분리, 의존성 방향, 패턴 일관성 |
| Code Quality | 25% | 컨벤션 준수, 가독성, 에러 처리 |
| UI/UX | 20% | 디자인 시스템, 접근성, 사용자 경험 |
| Maintainability | 15% | 다국어화, 문서화, 테스트 |
| Security | 10% | 데이터 보호, 메모리 안전성 |

### 점수 기준
- **9-10점**: Excellent - 모범 사례, 다른 팀 참고 권장
- **7-8점**: Good - 일반적 품질, 소폭 개선 권장
- **5-6점**: Fair - 평균 수준, 일부 개선 필요
- **3-4점**: Poor - 품질 우려, 상당한 개선 필요
- **1-2점**: Critical - 즉시 수정 필요, 리뷰 재요청

## 🔄 팀 워크플로우

### 1. 개발자
1. 기능 개발 완료
2. PR 생성 (자동 템플릿 적용)
3. 체크리스트 작성
4. 자동 검증 결과 확인
5. 피드백 반영

### 2. 리뷰어
1. PR 리뷰 요청 받음
2. 자동 검증 결과 확인
3. 범용 템플릿으로 리뷰 작성
4. 승인 또는 변경 요청

### 3. 팀 리드
1. 주기적 품질 메트릭 검토
2. 프로젝트별 규칙 조정
3. 팀 코딩 가이드라인 업데이트

## 🚨 문제 해결

### CI/CD 실패 시
```bash
# 로그 확인
gh run list --repo owner/repo
gh run view [RUN_ID] --log

# 로컬에서 테스트
./scripts/local-review.sh
```

### 설정 검증
```bash
# JSON 유효성 검사
cat .github/universal-codereview-config.json | jq '.'

# 환경 변수 확인
env | grep PROJECT
```

### 플랫폼별 도구 설치
```bash
# iOS
brew install swiftlint
curl -Ls https://install.tuist.io | bash

# Android
brew install ktlint

# Flutter
flutter --version
flutter doctor

# Node.js 기반
npm install -g eslint prettier
```

## 📚 추가 리소스

- [GitHub Actions 공식 문서](https://docs.github.com/en/actions)
- [PR 템플릿 가이드](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests)
- [코드 리뷰 모범 사례](https://google.github.io/eng-practices/review/)
- [Clean Architecture 가이드](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 🤝 기여 방법

1. 이 가이드를 개선하고 싶다면 PR을 보내주세요
2. 새로운 플랫폼 지원을 추가하고 싶다면 이슈를 생성해주세요
3. 버그나 개선사항이 있다면 피드백을 남겨주세요

---

**최신 업데이트:** 이 가이드는 지속적으로 업데이트됩니다. 주기적으로 확인하여 최신 모범 사례를 적용하세요.