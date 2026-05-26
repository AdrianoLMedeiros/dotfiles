# dotfiles — Adriano Medeiros

Repositório de configurações pessoais e ferramentas de desenvolvimento.
Mantido para sincronização entre máquinas de trabalho.

---

## Estrutura

```
dotfiles/
└── skills/
    └── dev-session-manager/   ← Skill do Claude Code para gestão de sessões
```

---

## Instalação em uma máquina nova

```bash
# 1. Clonar o repositório
git clone https://github.com/almedeirosm/dotfiles.git
cd dotfiles

# 2. Instalar as skills do Claude Code
bash skills/dev-session-manager/scripts/install.sh
```

## Atualização

```bash
cd dotfiles
git pull
bash skills/dev-session-manager/scripts/install.sh
```

---

## Skills incluídas

| Skill | Descrição |
|---|---|
| `dev-session-manager` | Registra e restaura sessões de desenvolvimento entre máquinas |
