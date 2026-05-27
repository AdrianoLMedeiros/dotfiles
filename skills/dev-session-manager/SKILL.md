---
name: dev-session-manager
description: >
  Gerencia sessões de trabalho de desenvolvimento entre máquinas diferentes.
  Use esta skill sempre que o usuário disser "encerrar sessão", "salvar sessão",
  "retomar o projeto [nome]", "continuar de onde parei", ou qualquer variação
  que indique troca de máquina ou retomada de contexto de desenvolvimento.
  A skill registra e restaura todo o estado necessário para o Claude Code
  operar com segurança em uma máquina com contexto desatualizado.
---

# Dev Session Manager

Skill para capturar e restaurar o estado completo de uma sessão de desenvolvimento,
permitindo retomada segura do trabalho entre máquinas diferentes.

## Comandos reconhecidos

| Frase do usuário | Ação |
|---|---|
| "encerrar sessão" | Executa o protocolo de encerramento e grava `.session.md` |
| "retomar o projeto [nome]" | Lê `.session.md` e executa o protocolo de retomada |
| "salvar sessão" | Alias para encerrar sessão |
| "continuar de onde parei" | Alias para retomar (usa projeto detectado pelo Git) |

---

## Protocolo de Encerramento

Ao detectar o comando de encerramento, execute **todos** os passos abaixo em ordem.
Não pergunte ao usuário — execute, colete, e só então apresente o resumo para validação.

### Passo 1 — Coletar estado do Git

```bash
# Projeto e branch
git rev-parse --show-toplevel   # raiz do projeto
git branch --show-current       # branch ativa
git status --short              # arquivos modificados/staged/untracked
git diff HEAD                   # diff completo dos arquivos modificados
git log --oneline -10           # últimos 10 commits
git stash list                  # stashes pendentes
```

### Passo 2 — Coletar estado do ambiente

```bash
# Dependências e runtime
node --version 2>/dev/null || echo "node: ausente"
java --version 2>/dev/null || echo "java: ausente"
python3 --version 2>/dev/null || echo "python: ausente"

# Processos ativos relacionados ao projeto (portas em uso)
lsof -i -P -n 2>/dev/null | grep LISTEN | grep -v "(LISTEN)" || \
  netstat -tlnp 2>/dev/null | grep LISTEN

# Variáveis de ambiente relevantes (sem expor secrets)
# Liste apenas as chaves, nunca os valores de variáveis sensíveis
env | grep -iE "^(NODE_ENV|APP_ENV|DATABASE_URL|PORT|HOST|JAVA_HOME|PYTHON)" \
  | sed 's/=.*/=[REDACTED]/'
```

### Passo 3 — Solicitar contexto ao usuário

Pergunte de forma concisa (uma única mensagem com todas as perguntas):

> "Antes de encerrar, preciso de algumas informações:
> 1. O que estava fazendo agora? (tarefa em andamento)
> 2. Qual é o próximo passo planejado?
> 3. Há alguma decisão de arquitetura tomada hoje que devo registrar?
> 4. Há erros ou bugs em aberto que não estão no código?"

### Passo 4 — Gravar `.session.md`

Use o template em `references/session-template.md`.

**REGRA CRÍTICA DE GRAVAÇÃO:**
O arquivo DEVE ser gravado na raiz do repositório Git do projeto — o mesmo
caminho retornado por `git rev-parse --show-toplevel` no Passo 1.

NUNCA use memória interna do Claude Code (`~/.claude/`, `memory/`, ou qualquer
caminho dentro do diretório de instalação do Claude). O arquivo precisa estar
no repositório para ser versionado e acessível em outras máquinas.

Execute a gravação com o caminho absoluto:

```bash
# Windows (Git Bash / MINGW)
PROJECT_ROOT=$(git rev-parse --show-toplevel)
# Exemplo de resultado esperado: /e/projetos/nexus

# Gravar o arquivo
cat > "${PROJECT_ROOT}/.session.md" << 'EOF'
[conteúdo gerado a partir do template]
EOF

# Confirmar que foi gravado no lugar certo
ls -la "${PROJECT_ROOT}/.session.md"
echo "Caminho absoluto: $(realpath ${PROJECT_ROOT}/.session.md)"
```

Após gravar, execute o commit e push automático:

```bash
cd "${PROJECT_ROOT}"
git add .session.md
git commit -m "session: encerramento $(date '+%Y-%m-%d %H:%M')"
git push
```

Se o push falhar (sem remote configurado, sem internet), informe o usuário
e oriente a fazer o push manualmente antes de trocar de máquina.

Após gravar, exiba um resumo compacto no chat:

```
Sessão encerrada — [PROJETO] @ [BRANCH]
Arquivo: [caminho absoluto]/.session.md
Push: OK / PENDENTE (motivo)
Próximo passo: [texto do próximo passo]
Pendências registradas: [N] itens
```

---

## Protocolo de Retomada

Ao detectar o comando de retomada, execute os passos abaixo em ordem.

### Passo 1 — Localizar o arquivo de sessão

O arquivo `.session.md` fica na raiz do repositório Git do projeto e chega
via `git pull` — o caminho local não importa, pois o Git sempre aponta para
a raiz correta independente de onde o projeto está clonado na máquina.

```bash
# Detectar raiz do repositório (funciona em qualquer máquina)
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

# Verificar se o arquivo existe
ls "${PROJECT_ROOT}/.session.md" 2>/dev/null || echo "ARQUIVO NÃO ENCONTRADO"
```

Se o arquivo não existir:
1. Oriente o usuário a rodar `git pull` e tente novamente.
2. Se ainda não existir após o pull, informe que nenhuma sessão foi registrada.

Se o usuário não estiver dentro de um repositório Git, pergunte o caminho
do projeto antes de prosseguir.

### Passo 2 — Ler e validar o arquivo

Leia o `.session.md` encontrado. Verifique:
- A data da sessão (alertar se for antiga, ex: mais de 7 dias)
- Se o branch registrado ainda existe: `git branch -a | grep [branch]`
- Se há stashes pendentes: `git stash list`

### Passo 3 — Reconciliar estado atual

```bash
# Verificar divergências entre o estado salvo e o estado atual
git status --short
git log --oneline -5
git diff HEAD
```

Se houver divergências (novos commits, arquivos modificados não registrados),
informe o usuário antes de prosseguir.

### Passo 4 — Apresentar briefing de retomada

Apresente um briefing estruturado no chat. Consulte o formato em
`references/briefing-template.md`. O briefing deve ser direto e orientado
à ação — o usuário precisa estar pronto para trabalhar em 2 minutos.

---

## Regras gerais

- **Nunca** exponha valores de variáveis de ambiente que contenham: password,
  secret, token, key, api_key, credential (use `[REDACTED]`).
- **Sempre** confirme com o usuário antes de sobrescrever um `.session.md`
  existente que foi gravado no mesmo dia.
- O diff completo vai para o arquivo `.session.md`, mas no chat exiba apenas
  o resumo (arquivos modificados, não o conteúdo do diff).
- Se o Git não estiver disponível no diretório atual, avise e prossiga coletando
  apenas as informações manuais (contexto do usuário).
- Ao retomar, leia o arquivo inteiro antes de exibir qualquer coisa ao usuário.

## Referências

- `references/session-template.md` — template do arquivo `.session.md`
- `references/briefing-template.md` — template do briefing de retomada
