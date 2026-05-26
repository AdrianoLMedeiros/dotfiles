# Dev Session Manager

Skill para o Claude Code que registra e restaura o estado completo de uma sessão
de desenvolvimento, permitindo retomar o trabalho entre máquinas diferentes
sem perder contexto.

---

## Instalação

A skill precisa ser instalada em **cada máquina** onde você usa o Claude Code.
A forma mais prática de manter isso sincronizado é guardar esta pasta em um
repositório Git (ex: `dotfiles`) e rodar o script de instalação em cada máquina.

### Opção A — Script automático (recomendado)

```bash
# Clone seu repositório de dotfiles (ou onde você guardar esta skill)
git clone https://github.com/seu-usuario/dotfiles.git
cd dotfiles/skills/dev-session-manager/scripts

# Rode o instalador
bash install.sh
```

O script detecta o sistema operacional, localiza o diretório correto do
Claude Code e copia os arquivos automaticamente.

### Opção B — Manual

Copie a pasta `dev-session-manager/` inteira para o diretório de skills
do Claude Code na sua máquina:

| Sistema | Caminho |
|---|---|
| macOS | `~/Library/Application Support/Claude/skills/` |
| Linux | `~/.config/claude/skills/` |
| Windows | `%APPDATA%\Claude\skills\` |

Após copiar, reinicie o Claude Code.

---

## Estrutura do repositório sugerida

Se você ainda não tem um repositório de dotfiles, esta é uma estrutura simples:

```
dotfiles/
├── README.md
└── skills/
    └── dev-session-manager/
        ├── README.md          ← este arquivo
        ├── SKILL.md
        ├── references/
        │   ├── session-template.md
        │   └── briefing-template.md
        └── scripts/
            └── install.sh
```

Em cada máquina nova:

```bash
git clone https://github.com/seu-usuario/dotfiles.git
bash dotfiles/skills/dev-session-manager/scripts/install.sh
```

---

## Uso

| O que você diz | O que acontece |
|---|---|
| `encerrar sessão` | Captura estado Git, ambiente e contexto → grava `.session.md` |
| `salvar sessão` | Mesmo que encerrar sessão |
| `retomar o projeto [nome]` | Lê `.session.md` → apresenta briefing completo |
| `continuar de onde parei` | Mesmo que retomar (detecta projeto pelo Git) |

O arquivo `.session.md` é gravado na **raiz do projeto**, junto com o código.
Recomenda-se adicioná-lo ao `.gitignore` se não quiser versionar as sessões,
ou versioná-lo se quiser histórico.

### `.gitignore` — ignorar sessões

```gitignore
# Sessões de desenvolvimento (Claude Code)
.session.md
```

### `.gitignore` — versionar sessões (histórico)

```gitignore
# Não ignorar — versionar intencionalmente
# .session.md
```

---

## O que é registrado numa sessão

- Projeto, branch ativa, hostname e data/hora
- `git status`, `git diff HEAD`, `git log` (últimos 10 commits), stashes
- Versões de runtime (Node, Java, Python)
- Portas ativas no momento do encerramento
- Chaves de variáveis de ambiente relevantes (valores nunca são expostos)
- Tarefa em andamento e próximo passo planejado
- Backlog e pendências
- Decisões de arquitetura da sessão
- Bugs e erros em aberto
- Changelog da sessão
- Notas livres

---

## Atualização

Para atualizar a skill após mudanças no repositório:

```bash
cd dotfiles
git pull
bash skills/dev-session-manager/scripts/install.sh
```
