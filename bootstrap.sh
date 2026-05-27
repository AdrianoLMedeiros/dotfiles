#!/usr/bin/env bash
# =============================================================================
# dotfiles — Bootstrap inicial
# Configura o repositório Git local e prepara para o primeiro push no GitHub.
# Uso: bash bootstrap.sh
# =============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_USER="almedeirosm"
REPO_NAME="dotfiles"
REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   dotfiles — Bootstrap inicial           ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Diretório : $REPO_DIR"
echo "Repositório: $REMOTE_URL"
echo ""

cd "$REPO_DIR"

# Inicializar Git se ainda não for um repositório
if [[ ! -d ".git" ]]; then
  echo "Inicializando repositório Git..."
  git init
  git branch -M main
else
  echo "Repositório Git já inicializado."
fi

# Configurar remote
if git remote get-url origin &>/dev/null; then
  echo "Remote 'origin' já configurado: $(git remote get-url origin)"
else
  echo "Configurando remote origin..."
  git remote add origin "$REMOTE_URL"
fi

# Primeiro commit
echo ""
echo "Preparando primeiro commit..."
git add .
git status --short

echo ""
read -r -p "Confirma o commit e push para o GitHub? [s/N] " resposta
if [[ ! "$resposta" =~ ^[Ss]$ ]]; then
  echo "Operação cancelada. Repositório configurado localmente."
  exit 0
fi

git commit -m "chore: estrutura inicial do dotfiles com dev-session-manager"

echo ""
echo "Fazendo push para o GitHub..."
echo "(Se solicitado, informe suas credenciais do GitHub)"
echo ""

git push -u origin main

echo ""
echo "Repositório publicado com sucesso!"
echo "Acesse: https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo ""
echo "Para instalar em outra máquina:"
echo "  git clone $REMOTE_URL"
echo "  bash dotfiles/skills/dev-session-manager/scripts/install.sh"
echo ""
