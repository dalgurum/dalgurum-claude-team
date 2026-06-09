# dalgurum-claude-team

Claude Code에서 사용하는 범용 개발 워크플로우 — Skills, 에이전트 팀, 서브에이전트 모음.

기획안 입력부터 인프라 구축까지 4단계 파이프라인으로 프로젝트를 진행한다.

---

## 전체 파이프라인

```
기획안 입력
  │
  ▼
[Skill 1] plan-enhancer
  전문 기획자 시선으로 기획안 보완
  → plan.md
  │
  ▼
[Skill 2] feature-extractor
  에이전트 팀 3개가 기능 목록 추출 + 기술 환경 제안
  → features.md / stack.md (사람용 상세)
  → features.summary.md / stack.summary.md (다음 단계용)
  │
  ▼
[Skill 3] design-discussion
  1라운드: architecture-team + ux-flow-team 설계 → Claude 종합
  2라운드: devil-advocate-team 검토 → 최종 확정
  → design/*.md (사람용 상세)
  → design/summary.md (다음 단계용)
  │
  ▼
[Skill 4] task-dispatcher
  설계 결과를 레이어별로 분배
  → infra-agent → backend-agent → frontend-agent (순차 실행)
```

---

## 구성 요소

### Skills (4개)

| 스킬 | 설명 |
|---|---|
| `plan-enhancer` | 기획안을 전문 기획자 시선으로 분석하고 보완하여 plan.md 생성 |
| `feature-extractor` | plan.md에서 구현 기능 목록 추출 및 기술 스택 제안 |
| `design-discussion` | 에이전트 팀 논의를 통한 기능별 최적 설계 도출 |
| `task-dispatcher` | 설계 결과를 서브에이전트에 분배하여 구현 진행 |

### 에이전트 팀 (설계/논의 전용, 3개)

| 에이전트 | 역할 |
|---|---|
| `architecture-team` | 시스템 아키텍처, 기술 스택, 컴포넌트 설계 |
| `ux-flow-team` | 사용자 시나리오, API 엔드포인트, UI 목업 |
| `devil-advocate-team` | 설계 약점 지적, 리스크 분석, 2차 검토 |

### 서브에이전트 (구현 전용, 3개)

| 에이전트 | 기본 스택 | 레이어 침범 금지 |
|---|---|---|
| `backend-agent` | Spring Boot + MySQL + JPA | 프론트 코드, IaC |
| `frontend-agent` | React + TypeScript | 백엔드 코드, IaC |
| `infra-agent` | AWS + Terraform (비용 절감 최우선) | 애플리케이션 코드 |

---

## 설치 방법

### Linux / Mac

```bash
git clone https://github.com/seongje00416/dalgurum-claude-team
cd dalgurum-claude-team
chmod +x install.sh
./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/seongje00416/dalgurum-claude-team
cd dalgurum-claude-team
.\install.ps1
```

설치 후 Claude Code를 재시작하면 적용됩니다.

---

## 설치 경로

```
~/.claude/
├── skills/
│   ├── plan-enhancer/
│   ├── feature-extractor/
│   ├── design-discussion/
│   └── task-dispatcher/
└── agents/
    ├── architecture-team.md
    ├── ux-flow-team.md
    ├── devil-advocate-team.md
    ├── backend-agent.md
    ├── frontend-agent.md
    └── infra-agent.md
```

---

## 업데이트

```bash
# Linux / Mac
git pull
./install.sh

# Windows
git pull
.\install.ps1
```

---

## 제거

```bash
# Linux / Mac
rm -rf ~/.claude/skills/plan-enhancer
rm -rf ~/.claude/skills/feature-extractor
rm -rf ~/.claude/skills/design-discussion
rm -rf ~/.claude/skills/task-dispatcher
rm ~/.claude/agents/architecture-team.md
rm ~/.claude/agents/ux-flow-team.md
rm ~/.claude/agents/devil-advocate-team.md
rm ~/.claude/agents/backend-agent.md
rm ~/.claude/agents/frontend-agent.md
rm ~/.claude/agents/infra-agent.md
```

```powershell
# Windows
Remove-Item -Recurse "$env:USERPROFILE\.claude\skills\plan-enhancer"
Remove-Item -Recurse "$env:USERPROFILE\.claude\skills\feature-extractor"
Remove-Item -Recurse "$env:USERPROFILE\.claude\skills\design-discussion"
Remove-Item -Recurse "$env:USERPROFILE\.claude\skills\task-dispatcher"
Remove-Item "$env:USERPROFILE\.claude\agents\architecture-team.md"
Remove-Item "$env:USERPROFILE\.claude\agents\ux-flow-team.md"
Remove-Item "$env:USERPROFILE\.claude\agents\devil-advocate-team.md"
Remove-Item "$env:USERPROFILE\.claude\agents\backend-agent.md"
Remove-Item "$env:USERPROFILE\.claude\agents\frontend-agent.md"
Remove-Item "$env:USERPROFILE\.claude\agents\infra-agent.md"
```
