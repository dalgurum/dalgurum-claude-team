#!/bin/bash

set -e

CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
AGENTS_DIR="$CLAUDE_DIR/agents"

echo "🚀 dalgurum-claude-team 설치를 시작합니다..."
echo ""

# ~/.claude 디렉토리 생성
mkdir -p "$SKILLS_DIR" "$AGENTS_DIR"

# Skills 설치
echo "📦 Skills 설치 중..."
for skill_dir in skills/*/; do
  skill_name=$(basename "$skill_dir")
  target="$SKILLS_DIR/$skill_name"

  if [ -d "$target" ]; then
    echo "  ⚠️  $skill_name — 이미 존재합니다. 덮어쓸까요? (y/N)"
    read -r answer
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
      echo "  ⏭️  $skill_name — 건너뜁니다"
      continue
    fi
    rm -rf "$target"
  fi

  cp -r "$skill_dir" "$target"
  echo "  ✅ $skill_name"
done

# Agents 설치
echo ""
echo "🤖 Agents 설치 중..."
for agent_file in agents/*.md; do
  agent_name=$(basename "$agent_file")
  target="$AGENTS_DIR/$agent_name"

  if [ -f "$target" ]; then
    echo "  ⚠️  $agent_name — 이미 존재합니다. 덮어쓸까요? (y/N)"
    read -r answer
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
      echo "  ⏭️  $agent_name — 건너뜁니다"
      continue
    fi
  fi

  cp "$agent_file" "$target"
  echo "  ✅ $agent_name"
done

echo ""
echo "✅ 설치 완료!"
echo ""
echo "설치 위치:"
echo "  Skills : $SKILLS_DIR"
echo "  Agents : $AGENTS_DIR"
echo ""
echo "설치된 Skills:"
for skill_dir in skills/*/; do
  echo "  - $(basename "$skill_dir")"
done
echo ""
echo "설치된 Agents:"
for agent_file in agents/*.md; do
  echo "  - $(basename "$agent_file" .md)"
done
echo ""
echo "Claude Code를 재시작하면 적용됩니다."
