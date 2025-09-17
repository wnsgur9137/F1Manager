## 📋 PR 체크리스트

### 변경사항 요약
<!-- PR의 주요 변경사항을 간략히 설명해주세요 -->

### 변경 유형
- [ ] 🐛 Bug fix (기존 기능을 수정하는 변경사항)
- [ ] ✨ New feature (새로운 기능을 추가하는 변경사항)
- [ ] 💥 Breaking change (기존 API를 변경하는 변경사항)
- [ ] 📝 Documentation update (문서 업데이트)
- [ ] ♻️ Code refactor (기능 변경 없는 코드 개선)
- [ ] ⚡ Performance improvement (성능 개선)
- [ ] 🧪 Test (테스트 추가 또는 수정)

### 🏗️ 아키텍처 체크리스트

#### Clean Architecture
- [ ] 3-layer 구조 준수 (Data, Domain, Presentation)
- [ ] 의존성 방향 올바름 (Data → Domain ← Presentation)
- [ ] 각 레이어별 책임 분리 적절

#### 모듈화 & 의존성
- [ ] Tuist 프로젝트 구조 준수
- [ ] DI Container 패턴 적용
- [ ] Protocol 기반 인터페이스 정의

### 🎨 코딩 컨벤션

#### Swift 네이밍
- [ ] PascalCase: Classes, Structs, Protocols
- [ ] camelCase: Variables, Functions, Enum cases
- [ ] 개별 addSubview 호출 (forEach 사용 금지)

#### F1 디자인 시스템
- [ ] F1 브랜딩 컬러 적용
- [ ] 일관된 UI 스타일링
- [ ] 적절한 그라데이션 및 그림자 효과

### 🌐 다국어화 & 품질

#### 다국어화
- [ ] 하드코딩된 문자열 없음
- [ ] NSLocalizedString 사용
- [ ] Localizable.strings 업데이트

#### 메모리 & 성능
- [ ] weak 참조 적절히 사용
- [ ] Retain cycle 방지
- [ ] 메모리 누수 체크 완료

#### 테스트
- [ ] 비즈니스 로직 단위 테스트 추가
- [ ] 기존 테스트 통과 확인
- [ ] 새로운 기능에 대한 테스트 커버리지

### 🔍 추가 정보

#### 관련 이슈
<!-- 관련된 이슈 번호를 적어주세요 (예: Closes #123) -->

#### 스크린샷 (UI 변경시)
<!-- UI 변경이 있다면 Before/After 스크린샷을 첨부해주세요 -->

#### 테스트 방법
<!-- 이 변경사항을 어떻게 테스트할 수 있는지 설명해주세요 -->

#### 추가 고려사항
<!-- 리뷰어가 특별히 주의해서 봐야 할 부분이 있다면 적어주세요 -->