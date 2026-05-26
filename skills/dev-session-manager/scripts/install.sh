#!/usr/bin/env bash
# =============================================================================
# dev-session-manager — Script de instalação
# Uso: bash install.sh
# =============================================================================

set -euo pipefail

SKILL_NAME="dev-session-manager"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ----------------------------------------------------------------------------
# Detectar sistema operacional
# ----------------------------------------------------------------------------
detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    *) echo "unknown" ;;
  esac
}

OS=$(detect_os)

# ----------------------------------------------------------------------------
# Localizar o diretório de skills do Claude Code
# Referência: https://docs.claude.ai/claude-code/skills
# ----------------------------------------------------------------------------
find_skills_dir() {
  local candidates=()

  if [[ "$OS" == "macos" ]]; then
    candidates=(
      "$HOME/Library/Application Support/Claude/skills"
      "$HOME/.claude/skills"
    )
  elif [[ "$OS" == "linux" ]]; then
    candidates=(
      "$HOME/.config/claude/skills"
      "$HOME/.claude/skills"
    )
  elif [[ "$OS" == "windows" ]]; then
    candidates=(
      "$APPDATA/Claude/skills"
      "$HOME/.claude/skills"
    )
  fi

  for dir in "${candidates[@]}"; do
    if [[ -d "$dir" ]]; then
      echo "$dir"
      return 0
    fi
  done

  # Nenhum encontrado — usar o padrão mais comum e criar
  local default="$HOME/.claude/skills"
  echo "$default"
}

SKILLS_DIR=$(find_skills_dir)
TARGET="$SKILLS_DIR/$SKILL_NAME"

# ----------------------------------------------------------------------------
# Execução
# ----------------------------------------------------------------------------
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Dev Session Manager — Instalação       ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Sistema operacional : $OS"
echo "Diretório de skills : $SKILLS_DIR"
echo "Destino             : $TARGET"
echo ""

# Confirmar
read -r -p "Confirma a instalação? [s/N] " resposta
if [[ ! "$resposta" =~ ^[Ss]$ ]]; then
  echo "Instalação cancelada."
  exit 0
fi

# Criar diretório de skills se não existir
mkdir -p "$SKILLS_DIR"

# Remover versão anterior se existir
if [[ -d "$TARGET" ]]; then
  echo ""
  echo "Versão anterior encontrada. Removendo..."
  rm -rf "$TARGET"
fi

# Copiar skill
cp -r "$SKILL_DIR" "$TARGET"

echo ""
echo "Instalado com sucesso em:"
echo "  $TARGET"
echo ""
echo "Arquivos instalados:"
find "$TARGET" -type f | sed "s|$TARGET/||" | sort | sed 's/^/  /'
echo ""
echo "Próximos passos:"
echo "  1. Reinicie o Claude Code (se estiver aberto)"
echo "  2. Em qualquer projeto, diga: 'encerrar sessão'"
echo "  3. Na outra máquina, diga: 'retomar o projeto [nome]'"
echo ""
