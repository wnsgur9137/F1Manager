# MCP (Model Context Protocol) Setup for F1Manager

F1Manager 프로젝트에서 MCP를 통한 자동화된 코드 리뷰 및 개발 도구를 설정하는 가이드입니다.

## 🚀 Quick Start

### 1. 환경 변수 설정

```bash
# .env 파일 생성
cp .env.example .env

# API 키 설정
vim .env
```

필요한 API 키들:
- `OPENAI_API_KEY`: OpenAI API 키 (코드 리뷰용)
- `ANTHROPIC_API_KEY`: Anthropic API 키 (Claude 모델용)
- `GITHUB_TOKEN`: GitHub Personal Access Token

### 2. Claude Code에서 사용

```bash
# 프로젝트 디렉토리에서 Claude Code 실행
claude-code --mcp-debug

# 또는 MCP 서버와 함께 실행
claude-code --mcp-config .mcp.json
```

## 📋 MCP 서버 구성

### code-reviewer
- **목적**: 자동화된 코드 리뷰
- **모델**: OpenAI GPT-4 또는 Claude
- **기능**:
  - Clean Architecture 검증
  - Swift 컨벤션 체크
  - F1 디자인 시스템 준수 확인
  - 메모리 관리 검증

### github-mcp
- **목적**: GitHub API 통합
- **기능**:
  - PR 생성/관리
  - 이슈 트래킹
  - 리뷰 댓글 작성

### f1manager-linter
- **목적**: SwiftLint 통합
- **기능**:
  - 코드 스타일 검사
  - 커스텀 규칙 적용
  - F1Manager 특화 규칙

## 🏗️ 코드 리뷰 규칙

### Clean Architecture 검증

```json
{
  "cleanArchitecture": {
    "enforceLayerSeparation": true,
    "dataLayer": ["Repository", "DataSource", "DTO"],
    "domainLayer": ["UseCase", "Entity", "Repository"],
    "presentationLayer": ["ViewController", "Reactor", "View"],
    "dependencyDirection": "data->domain<-presentation"
  }
}
```

### F1Manager 특화 규칙

1. **forEach addSubview 금지**
   ```swift
   // ❌ 금지
   subviews.forEach { containerView.addSubview($0) }

   // ✅ 권장
   containerView.addSubview(titleLabel)
   containerView.addSubview(subtitleLabel)
   ```

2. **다국어화 필수**
   ```swift
   // ❌ 금지
   label.text = "홈"

   // ✅ 권장
   label.text = NSLocalizedString("tab.home.title", comment: "")
   ```

3. **Coordinator 패턴 메모리 관리**
   ```swift
   // ✅ 권장
   public weak var finishDelegate: CoordinatorFinishDelegate?
   public weak var navigationController: UINavigationController?
   ```

## 🔧 사용 방법

### 1. 자동 코드 리뷰

```bash
# PR 생성시 자동으로 실행되지만, 수동으로도 가능
claude-code review --config .github/codereview-config.json
```

### 2. GitHub 통합

```bash
# PR 정보 조회
claude-code github pr list

# 리뷰 댓글 작성
claude-code github pr review 13 --comprehensive
```

### 3. 린트 실행

```bash
# SwiftLint 실행
claude-code lint --config .swiftlint.yml
```

## 📊 코드 품질 메트릭

### 평가 기준

| 카테고리 | 가중치 | 체크 항목 |
|----------|--------|-----------|
| Architecture Compliance | 30% | Clean Architecture, DI, Coordinator |
| Code Quality | 25% | Swift 컨벤션, 가독성, 에러 처리 |
| UI Consistency | 20% | F1 디자인 시스템, 반응형 |
| Maintainability | 15% | 다국어화, 문서화, 테스트 |
| Security | 10% | 보안, 메모리 안전성 |

### 점수 기준

- **9-10점**: Excellent - 모범 사례
- **7-8점**: Good - 약간의 개선 필요
- **5-6점**: Fair - 중간 수준의 개선 필요
- **3-4점**: Poor - 상당한 개선 필요
- **1-2점**: Critical - 전면 재작업 필요

## 🚨 문제 해결

### MCP 서버 연결 실패

```bash
# 디버그 모드로 실행
claude-code --mcp-debug

# 환경 변수 확인
echo $ANTHROPIC_API_KEY
echo $GITHUB_TOKEN
```

### 설정 파일 문제

```bash
# JSON 유효성 검사
cat .mcp.json | jq '.'

# 권한 확인
ls -la .mcp.json .env
```

### API 키 관련 이슈

1. GitHub Token 권한 확인
   - `repo` 스코프 필요
   - `pull_request` 권한 필요

2. Anthropic API 키 확인
   - 유효한 API 키인지 확인
   - 사용량 한도 확인

## 📚 추가 리소스

- [MCP 공식 문서](https://docs.anthropic.com/en/docs/claude-code/mcp)
- [F1Manager 아키텍처 가이드](./CLAUDE.md)
- [코드 리뷰 템플릿](./.github/PR_REVIEW_TEMPLATE.md)
- [Swift 컨벤션 가이드](./.github/f1manager-review-rules.md)