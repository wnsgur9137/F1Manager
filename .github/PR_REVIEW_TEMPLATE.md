# PR Review Template for F1Manager

## Overall Assessment Format

```markdown
## PR #{number} Review: {Feature Name}

### 🎯 Overall Assessment
**Rating: {score}/10** - {brief summary}

### ✅ Strengths
- **{Category}**: {description}
- **{Category}**: {description}
- **{Category}**: {description}

### ⚠️ Areas for Improvement

#### High Priority
1. **{Issue Title}**
   ```swift
   // Current code example
   ```
   → {recommended solution}

2. **{Issue Title}**
   ```swift
   // Current code example
   ```
   → {recommended solution}

#### Medium Priority
- {improvement item}
- {improvement item}

### 🏗️ Architecture Quality
| Category | Score | Notes |
|----------|--------|-------|
| Clean Architecture | {score}/10 | {notes} |
| Swift Conventions | {score}/10 | {notes} |
| Module Structure | {score}/10 | {notes} |
| Memory Management | {score}/10 | {notes} |

### 💡 Recommendations
{overall recommendations and next steps}

**Next Steps:**
1. {step 1}
2. {step 2}
3. {step 3}

{closing message} 🚀
```

## Line-Specific Comment Templates

### 1. 다국어화 필요
```markdown
**다국어화 필요** 🌐

하드코딩된 문자열은 프로젝트 가이드라인에 위배됩니다. `Localizable.strings` 파일을 사용해주세요.

```swift
// 권장사항
case .home: return NSLocalizedString("tab.home.title", comment: "Home tab title")
case .settings: return NSLocalizedString("tab.settings.title", comment: "Settings tab title")
```
```

### 2. 미구현 기능
```markdown
**{기능명} 미구현** ⚠️

`{methodName}()` 메서드가 비어있습니다. {설명}이 필요합니다.

```swift
// 예시 구현
{example code}
```
```

### 3. 아키텍처 구현 미완료
```markdown
**{Layer} Layer 구현 필요** {emoji}

{설명}

```swift
// 필요한 구현들
{example interfaces or classes}
```
```

### 4. DI Container 관련
```markdown
**DI Container 구현 미완료** 🔧

{설명}

```swift
// 추가 필요 메서드들
{required methods}
```
```

### 5. 메모리 관리
```markdown
**메모리 관리 개선** 🔄

{설명}

```swift
// 권장사항
{memory management solution}
```
```

### 6. 성능 최적화
```markdown
**성능 최적화 권장** ⚡

{설명}

```swift
// 최적화 방안
{optimization code}
```
```

## F1Manager 프로젝트 특화 체크리스트

### Architecture Compliance
- [ ] Clean Architecture 3-layer 구조 준수
- [ ] Tuist 모듈화 올바른 적용
- [ ] Coordinator 패턴 적절한 구현
- [ ] ReactorKit 패턴 사용 (해당시)

### Swift Conventions
- [ ] PascalCase for Classes/Structs
- [ ] camelCase for Variables/Functions
- [ ] Enum cases camelCase
- [ ] 개별 addSubview 호출 (forEach 금지)

### F1 Design System
- [ ] F1 브랜딩 컬러 사용
- [ ] 일관된 UI 스타일링
- [ ] 적절한 그라데이션 효과
- [ ] 카드 기반 레이아웃

### Dependency Management
- [ ] DI Container 패턴 준수
- [ ] Protocol 기반 인터페이스
- [ ] 올바른 의존성 방향

### Memory & Performance
- [ ] weak 참조 적절한 사용
- [ ] Retain cycle 방지
- [ ] 메모리 사용량 최적화

### Localization & Testing
- [ ] 다국어화 적용 (Localizable.strings)
- [ ] 적절한 테스트 커버리지
- [ ] Mock 객체 활용

## 점수 기준

| 점수 | 평가 |
|------|------|
| 9-10 | Excellent - 모범 사례 |
| 7-8 | Good - 약간의 개선 필요 |
| 5-6 | Fair - 중간 수준의 개선 필요 |
| 3-4 | Poor - 상당한 개선 필요 |
| 1-2 | Critical - 전면 재작업 필요 |

## 이모지 가이드

- 🎯 Overall Assessment
- ✅ Strengths
- ⚠️ Areas for Improvement
- 🏗️ Architecture
- 💡 Recommendations
- 🚀 Encouragement
- 🌐 Localization
- 🔧 Technical Implementation
- 📊 Data Layer
- 🎨 UI/Presentation
- 🔄 Memory Management
- ⚡ Performance