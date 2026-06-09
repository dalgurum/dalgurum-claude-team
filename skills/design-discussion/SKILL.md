---
name: design-discussion
description: >
  features.summary.md와 stack.summary.md가 준비된 상태에서 에이전트 팀 3개가
  기능별 최적 설계를 논의하고 devil-advocate-team과 2차 검토를 거쳐 최종 설계 결과를
  design/ 디렉토리에 md 파일로 출력한다. 사람용 상세 버전과 다음 단계용 요약 버전을 함께 생성한다.
  다음과 같은 요청에 반드시 이 스킬을 적용하라:
  - "설계해줘", "아키텍처 설계해줘", "기능 설계 시작해줘"
  - features.summary.md 또는 features.md가 존재하는 경우
  - "design-discussion 실행해줘"
---

# Design Discussion Skill

`features.summary.md`와 `stack.summary.md`를 입력으로 받아 에이전트 팀이 설계를 논의하고
최종 설계 결과를 `design/` 디렉토리에 출력한다.

논의는 2라운드로 진행된다:
1. **1라운드**: architecture-team + ux-flow-team이 각자 설계안 제시 → Claude 종합
2. **2라운드**: Claude 종합안을 devil-advocate-team과 검토 → 최종 확정

---

## 1단계: 입력 파일 로드

아래 파일을 순서대로 읽는다.

```
features.summary.md   (필수 — 없으면 feature-extractor 먼저 실행 안내 후 중단)
stack.summary.md      (필수 — 없으면 feature-extractor 먼저 실행 안내 후 중단)
```

---

## 2단계: 1라운드 — 설계안 도출

### architecture-team 에게 요청할 것
- 전체 시스템 아키텍처 (컴포넌트 구성, 서비스 분리 기준)
- 각 기능의 백엔드 설계 (API 구조, DB 스키마 초안, 주요 로직)
- 서비스 간 통신 방식 (REST / gRPC / 이벤트)
- 인프라 구성 요소 (필요한 AWS 서비스 목록)

### ux-flow-team 에게 요청할 것
- 각 기능의 API 엔드포인트 목록 (Method, Path, 요청/응답 구조)
- 사용자 시나리오별 화면 흐름 (Mermaid flowchart)
- UI 컴포넌트 구성 (주요 페이지, 컴포넌트 트리)

### Claude 종합 기준
- 두 팀의 설계가 충돌하는 경우: 기술적 타당성을 기준으로 판단
- 두 팀의 설계가 보완적인 경우: 통합하여 단일 설계안으로 구성
- 누락된 부분: Claude가 직접 채운다

---

## 3단계: 2라운드 — devil-advocate-team 검토

Claude 종합안 전문을 devil-advocate-team에게 전달하고 아래를 요청한다.

- 설계의 약점 및 단일 장애점 (SPOF)
- 과도하게 복잡한 부분 (단순화 가능 여부)
- 보안 취약점 가능성
- 운영/장애 대응 관점의 리스크

### Claude 최종 확정 기준
- devil-advocate-team 지적이 타당한 경우: 설계 수정
- 지적이 과도하거나 현실적으로 불필요한 경우: 근거와 함께 원안 유지
- 수정/유지 결정 내역을 반드시 기록

---

## 4단계: design/ 디렉토리 출력

`design/` 디렉토리를 생성하고 아래 파일을 출력한다.

### design/architecture.md
```markdown
# 시스템 아키텍처 설계

## 전체 구성도 (Mermaid)
## 컴포넌트 설명
## 서비스 간 통신 방식
## 주요 기술 선택 근거
```

### design/api-spec.md
```markdown
# API 명세

## 엔드포인트 목록
| Method | Path | 설명 | 요청 | 응답 |
|---|---|---|---|---|

## 주요 요청/응답 스키마
```

### design/ux-flow.md
```markdown
# UX 플로우

## 사용자 시나리오별 화면 흐름 (Mermaid flowchart)
## UI 컴포넌트 트리
## 주요 페이지 목업 (Mermaid)
```

### design/db-schema.md
```markdown
# DB 스키마 설계

## ERD (Mermaid erDiagram)
## 테이블 정의
## 인덱스 전략
```

### design/infra-plan.md
```markdown
# 인프라 설계

## AWS 서비스 구성도 (Mermaid)
## 서비스별 사용 목적
## 비용 추정
## 네트워크 구성 (VPC, 서브넷)
```

### design/devil-advocate-review.md
```markdown
# Devil Advocate 검토 결과

## 지적 사항 목록
| 항목 | 지적 내용 | 처리 결과 (수정/유지) | 근거 |
|---|---|---|---|
```

### design/summary.md (다음 단계용 요약 버전)
```markdown
# 설계 요약 (task-dispatcher 입력용)

## 백엔드 구현 목록
- [기능명]: [구현 내용 한 줄 요약] / API: [엔드포인트] / DB: [관련 테이블]

## 프론트엔드 구현 목록
- [기능명]: [구현 내용 한 줄 요약] / 페이지: [해당 화면]

## 인프라 구현 목록
- [서비스명]: [구성 내용 한 줄 요약] / tf 파일명: [파일명]

## 구현 순서 제약
- [A]는 [B] 완료 후 시작 가능
```

---

## 주의사항

- 모든 다이어그램은 Mermaid 문법으로 작성한다
- devil-advocate-team 검토 결과는 반드시 `devil-advocate-review.md`에 기록한다
- 설계 변경 시 연관된 모든 파일을 함께 업데이트한다
- 출력 후 사용자에게 `task-dispatcher` 스킬로 다음 단계 진행 가능함을 안내한다
