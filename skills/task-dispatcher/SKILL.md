---
name: task-dispatcher
description: >
  design/summary.md가 준비된 상태에서 설계 결과를 분석하여 backend-agent, frontend-agent,
  infra-agent에게 레이어별로 작업을 분배하고 순차적으로 구현을 진행한다.
  레이어 간 침범은 절대 허용되지 않으며 안정성을 최우선으로 순서를 결정한다.
  다음과 같은 요청에 반드시 이 스킬을 적용하라:
  - "구현 시작해줘", "개발 시작해줘", "코드 작성해줘"
  - design/summary.md 또는 design/ 디렉토리가 존재하는 경우
  - "task-dispatcher 실행해줘"
---

# Task Dispatcher Skill

`design/summary.md`를 읽고 각 서브에이전트에게 작업을 분배하여 순차적으로 구현을 진행한다.

**핵심 원칙**: 안정성 우선, 레이어 침범 금지, 의존성 순서 준수

---

## 1단계: 입력 파일 로드

```
design/summary.md     (필수 — 없으면 design-discussion 먼저 실행 안내 후 중단)
```

상세 설계가 필요한 경우 아래 파일도 참조한다.
```
design/architecture.md
design/api-spec.md
design/db-schema.md
design/ux-flow.md
design/infra-plan.md
```

---

## 2단계: 작업 분류 및 순서 결정

### 레이어별 작업 분류 기준

| 작업 유형 | 담당 에이전트 |
|---|---|
| API 구현, 비즈니스 로직, DB 마이그레이션, 서버 설정 | `backend-agent` |
| UI 컴포넌트, 페이지, 라우팅, API 연동 | `frontend-agent` |
| Terraform 파일, K8s 매니페스트, CI/CD 파이프라인 | `infra-agent` |

### 구현 순서 결정 원칙 (안정성 우선)

```
1. infra-agent    — 인프라 먼저 (실행 환경 구성)
2. backend-agent  — 백엔드 (API, DB)
3. frontend-agent — 프론트엔드 (API 완성 후 연동)
```

단, `design/summary.md`의 **구현 순서 제약** 섹션에 명시된 의존성이 있으면 그것을 우선한다.

---

## 3단계: 에이전트별 작업 지시

각 에이전트에게 아래 형식으로 작업을 지시한다.

### infra-agent 지시 형식
```
[infra-agent]
다음 인프라를 구성하세요.

구현 목록:
- [서비스명]: [구성 내용] → [tf 파일명]

참조 파일: design/infra-plan.md
제약 조건:
- Terraform으로 작성, 서비스별 별도 tf 파일
- 비용 절감 최우선
- AWS 우선 (불가피한 경우에만 NCP → GCP 순으로 대체)
```

### backend-agent 지시 형식
```
[backend-agent]
다음 기능을 구현하세요.

구현 목록:
- [기능명]: [구현 내용] / API: [엔드포인트] / DB: [관련 테이블]

참조 파일: design/api-spec.md, design/db-schema.md
제약 조건:
- Spring Boot + MySQL + JPA 사용 (성능상 이점이 명확한 경우만 예외)
- 프론트엔드 코드, IaC 작성 금지
```

### frontend-agent 지시 형식
```
[frontend-agent]
다음 화면을 구현하세요.

구현 목록:
- [기능명]: [구현 내용] / 페이지: [해당 화면]

참조 파일: design/ux-flow.md, design/api-spec.md
제약 조건:
- React + TypeScript 사용 (성능상 이점이 명확한 경우만 예외)
- 백엔드 코드, IaC 작성 금지
```

---

## 4단계: 진행 상황 관리

각 에이전트 작업 완료 후 아래를 확인한다.

- [ ] 레이어 침범 여부 (다른 레이어 코드 작성 여부)
- [ ] 설계 명세(`design/`) 준수 여부
- [ ] 다음 에이전트가 필요로 하는 인터페이스(API, 인프라 엔드포인트) 완성 여부

문제 발견 시 해당 에이전트에게 수정을 요청하고 다음 단계로 넘어가지 않는다.

---

## 주의사항

- 에이전트 간 작업 순서를 반드시 지킨다 (병렬 실행 금지)
- 각 에이전트는 자신의 레이어만 담당한다 — 다른 레이어 코드 발견 시 즉시 수정 요청
- 인프라가 준비되지 않은 상태에서 백엔드 구현을 시작하지 않는다
- 백엔드 API가 완성되지 않은 상태에서 프론트엔드 API 연동을 시작하지 않는다
