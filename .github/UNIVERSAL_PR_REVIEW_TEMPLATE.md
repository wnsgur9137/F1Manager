# Universal PR Review Template

## Overall Assessment Format

```markdown
## 🎯 Automated Code Review - PR #{number}

**제목:** {PR Title}
**변경사항:** {Brief Summary} ({additions} additions, {deletions} deletions)
**설정 기반 분석:** `.github/codereview-config.json` 규칙 적용

---

## 📊 Code Quality Metrics (Config-Based Analysis)

### ✅ **Swift Conventions Compliance: {score}/10**
- **PascalCase**: Classes/Structs {status} ({examples})
- **camelCase**: Variables/Functions {status} ({examples})
- **Enum Cases**: {status} ({examples})

### 🏗️ **Architecture Adherence: {score}/10**
- **Layer Separation**: {status} ({details})
- **Dependency Direction**: {status} ({architecture_pattern})
- **Pattern Consistency**: {status} ({patterns_used})

### 🎨 **Design System Implementation: {score}/10**
- **Branding Consistency**: {status} ({color_usage})
- **Component Library**: {status} ({components_used})
- **Styling Patterns**: {status} ({styling_approach})

### 🔧 **Code Implementation Quality: {score}/10**

#### ✅ **Strengths**
1. **{Category}**
   ```swift
   // Example of good implementation
   {code_example}
   ```

2. **{Category}**
   ```swift
   // Another example
   {code_example}
   ```

#### ⚠️ **Areas for Improvement**

1. **{Issue Category}** (Config Rule: {rule_name})
   ```swift
   // Line {number}: Issue description
   {problematic_code}

   // 권장사항
   {recommended_solution}
   ```

### 💾 **Memory Management: {score}/10**
- **Retain Cycles**: {status} ({details})
- **Resource Management**: {status} ({details})

### 🧪 **Testing Considerations: {score}/10**
- **Test Coverage**: {coverage}% (Target: {target}%)
- **Test Quality**: {status} ({details})

---

## 🏆 **Overall Assessment: {overall_score}/10**

### 🚀 **Exceptional Achievements**
- {achievement_1}
- {achievement_2}
- {achievement_3}

### 🎯 **Recommended Actions**

1. **High Priority**
   ```swift
   // {description}
   {code_example}
   ```

2. **Medium Priority**
   ```swift
   // {description}
   {code_example}
   ```

3. **Future Enhancement**
   - {enhancement_1}
   - {enhancement_2}

---

## 📈 **{ProjectType} Best Practices Compliance: {compliance_score}%**

**결론:** {conclusion_statement}
```

## Line-Specific Comment Templates

### 1. 다국어화 필요 (Universal)
```markdown
**다국어화 필요** 🌐

하드코딩된 문자열은 유지보수성을 해칩니다. 국제화를 위해 리소스 파일을 사용해주세요.

```swift
// 권장사항 (iOS)
case .home: return NSLocalizedString("tab.home.title", comment: "Home tab title")

// 권장사항 (Android)
case .home: return getString(R.string.tab_home_title)

// 권장사항 (Flutter)
case .home: return AppLocalizations.of(context)!.tabHomeTitle
```
```

### 2. 아키텍처 위반 (Universal)
```markdown
**아키텍처 레이어 위반** 🏗️

{Layer} 레이어에서 {Target} 레이어를 직접 참조하고 있습니다. 의존성 방향을 확인해주세요.

```swift
// 문제: Data layer가 Presentation을 import
import SomePresentation

// 권장사항: 인터페이스를 통한 의존성 역전
protocol SomeRepositoryInterface {
    // Define interface in Domain layer
}
```
```

### 3. 메모리 관리 (Universal)
```markdown
**메모리 관리 개선** 🔄

강한 참조로 인한 순환 참조 가능성이 있습니다. 약한 참조 사용을 권장합니다.

```swift
// 문제점
public var delegate: SomeDelegate?

// 권장사항
public weak var delegate: SomeDelegate?

// 클로저에서의 약한 참조
someService.performAction { [weak self] result in
    self?.handleResult(result)
}
```
```

### 4. 성능 최적화 (Universal)
```markdown
**성능 최적화 권장** ⚡

{specific_issue_description}

```swift
// 현재 구현
{current_code}

// 최적화 방안
{optimized_code}
```

**예상 개선:**
- 메모리 사용량: {memory_improvement}
- 실행 시간: {performance_improvement}
```

### 5. 보안 이슈 (Universal)
```markdown
**보안 취약점** 🔒

{security_issue_description}

```swift
// 취약한 코드
{vulnerable_code}

// 보안 개선
{secure_code}
```

**보안 가이드라인:**
- API 키는 환경 변수 또는 보안 저장소 사용
- 사용자 데이터는 암호화하여 저장
- 네트워크 통신은 HTTPS 사용
```

### 6. 테스트 커버리지 (Universal)
```markdown
**테스트 커버리지 부족** 🧪

새로운 비즈니스 로직에 대한 테스트가 누락되었습니다.

```swift
// 테스트 대상
{production_code}

// 권장 테스트
class {ClassName}Tests: XCTestCase {
    func test{FunctionName}_when{Condition}_should{ExpectedResult}() {
        // Given
        // When
        // Then
    }
}
```
```

## Platform-Specific Templates

### iOS/Swift 특화
```markdown
**SwiftUI/UIKit 모범 사례** 📱

{specific_ios_guidance}

```swift
// iOS 권장사항
{ios_specific_code}
```
```

### Android/Kotlin 특화
```markdown
**Android/Kotlin 모범 사례** 🤖

{specific_android_guidance}

```kotlin
// Android 권장사항
{android_specific_code}
```
```

### Flutter/Dart 특화
```markdown
**Flutter/Dart 모범 사례** 🦋

{specific_flutter_guidance}

```dart
// Flutter 권장사항
{flutter_specific_code}
```
```

## Configuration Variables Guide

### Project-Specific Customization
```bash
# .env file example
PROJECT_NAME="YourProjectName"
PROJECT_TYPE="ios-swift"  # ios-swift, android-kotlin, flutter-dart, react-native
ARCHITECTURE="clean-architecture"  # clean-architecture, mvvm, viper, redux

# Review Weights (총합 100%)
ARCHITECTURE_WEIGHT=30
CODE_QUALITY_WEIGHT=25
UI_WEIGHT=20
MAINTAINABILITY_WEIGHT=15
SECURITY_WEIGHT=10

# Feature Flags
ENFORCE_LAYERS=true
DESIGN_CONSISTENCY=true
REQUIRE_LOCALIZATION=true
COVERAGE_THRESHOLD=70
```

### Pattern-Specific Rules
```json
{
  "ios-swift": {
    "prohibitedPatterns": ["forEach.*addSubview", "force_unwrap"],
    "recommendedPatterns": ["weak_delegates", "individual_addsubview"]
  },
  "android-kotlin": {
    "prohibitedPatterns": ["!!_operator", "lateinit_abuse"],
    "recommendedPatterns": ["sealed_classes", "coroutines"]
  },
  "flutter-dart": {
    "prohibitedPatterns": ["setState_abuse", "widget_rebuild"],
    "recommendedPatterns": ["provider_pattern", "bloc_pattern"]
  }
}
```

## Usage Instructions

1. **Copy template files** to your project's `.github` directory
2. **Create `.env` file** with project-specific variables
3. **Customize** `universal-codereview-config.json` for your needs
4. **Set up CI/CD** integration with your chosen platform
5. **Train team** on review criteria and processes

## Supported Platforms

- ✅ iOS (Swift/SwiftUI/UIKit)
- ✅ Android (Kotlin/Java)
- ✅ Flutter (Dart)
- ✅ React Native (TypeScript/JavaScript)
- ✅ Web (React/Vue/Angular)

## Integration Examples

### GitHub Actions
```yaml
- name: Universal Code Review
  uses: ./universal-code-review
  with:
    config-path: .github/universal-codereview-config.json
    platform: ${{ env.PROJECT_TYPE }}
```

### GitLab CI
```yaml
code_review:
  script:
    - universal-code-review --config .github/universal-codereview-config.json
```