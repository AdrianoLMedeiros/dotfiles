---
name: dev-session-manager
description: >
  Gerencia sessões de trabalho de desenvolvimento entre máquinas diferentes.
  Ativado EXCLUSIVAMENTE pelos comandos exatos "handoff-sk" (encerrar sessão)
  e "pickup-sk" (retomar sessão). Ao detectar esses comandos, execute
  imediatamente o protocolo correspondente sem aguardar instruções adicionais.
---

# Dev Session Manager

## GATILHOS

| Comando exato | Ação imediata |
|---|---|
| `handoff-sk` | Executar PROTOCOLO DE ENCERRAMENTO completo |
| `pickup-sk` | Executar PROTOCOLO DE RETOMADA completo |

Qualquer outra frase, mesmo similar, NÃO aciona esta skill.

---

## PROTOCOLO DE ENCERRAMENTO (`handoff-sk`)

Execute cada passo em sequência. Não pule etapas. Não peça confirmação antes
de coletar — colete tudo primeiro, pergunte depois.

### PASSO 1 — Detectar raiz do projeto

Execute no terminal:

```bash
git rev-parse --show-toplevel
```

Armazene o resultado como PROJECT_ROOT. Se falhar, informe o usuário que
não há repositório Git no diretório atual e encerre o protocolo.

### PASSO 2 — Coletar estado do Git

Execute cada comando e armazene os resultados:

```bash
git branch --show-current
git status --short
git diff HEAD
git log --oneline -10
git stash list
```

### PASSO 3 — Coletar estado do ambiente

```bash
node --version 2>/dev/null || echo "ausente"
java --version 2>/dev/null || echo "ausente"
python3 --version 2>/dev/null || echo "ausente"
netstat -ano 2>/dev/null | findstr LISTENING || netstat -tlnp 2>/dev/null | grep LISTEN
set | findstr /i "NODE_ENV PORT HOST DATABASE" 2>/dev/null || \
  env | grep -iE "NODE_ENV|PORT|HOST|DATABASE" | sed 's/=.*/=[REDACTED]/'
```

### PASSO 4 — Perguntar contexto ao usuário

Envie exatamente esta mensagem, numa única vez:

---
**handoff-sk — Contexto da sessão**

Responda as 4 perguntas para registrar a sessão:

1. O que estava fazendo agora?
2. Qual é o próximo passo planejado?
3. Alguma decisão de arquitetura tomada hoje?
4. Bugs ou erros em aberto que não estão no código?
---

Aguarde a resposta antes de continuar.

### PASSO 5 — Gravar `.session.md`

Monte o arquivo usando o template em `references/session-template.md`.
Grave com o caminho absoluto detectado no Passo 1:

```bash
# O arquivo VAI para a raiz do repositório Git — NUNCA para ~/.claude/ ou memory/
cat > "${PROJECT_ROOT}/.session.md" << 'EOF'
[conteúdo montado a partir do template]
EOF
```

Confirme a gravação:

```bash
ls -la "${PROJECT_ROOT}/.session.md"
```

### PASSO 6 — Commit e push

```bash
cd "${PROJECT_ROOT}"
git add .session.md
git commit -m "session: handoff $(date '+%Y-%m-%d %H:%M')"
git push
```

Se o push falhar, informe o usuário e peça que faça manualmente antes de
trocar de máquina.

### PASSO 7 — Confirmar encerramento

Exiba no chat:

```
handoff-sk concluído
Projeto : [nome do projeto]
Branch  : [branch]
Arquivo : [PROJECT_ROOT]/.session.md
Push    : OK | PENDENTE
Próximo : [próximo passo respondido pelo usuário]
```

---

## PROTOCOLO DE RETOMADA (`pickup-sk`)

### PASSO 1 — Detectar raiz do projeto

```bash
git rev-parse --show-toplevel
```

Se falhar, pergunte ao usuário o caminho do projeto antes de continuar.

### PASSO 2 — Verificar e ler `.session.md`

```bash
PROJECT_ROOT=$(git rev-parse --show-toplevel)
cat "${PROJECT_ROOT}/.session.md"
```

Se o arquivo não existir:
1. Oriente: `git pull` para baixar da outra máquina.
2. Tente novamente após o pull.
3. Se ainda não existir, informe que nenhuma sessão foi registrada.

### PASSO 3 — Reconciliar estado atual

```bash
git status --short
git log --oneline -5
git stash list
```

Se houver divergências com o que está registrado no `.session.md`, destaque
as diferenças antes de exibir o briefing.

### PASSO 4 — Exibir briefing

Monte e exiba o briefing usando `references/briefing-template.md`.
O briefing deve ser direto — o usuário precisa estar pronto para trabalhar
em menos de 2 minutos.

---

## REGRAS INVIOLÁVEIS

1. NUNCA grave o arquivo em `~/.claude/`, `memory/`, ou qualquer caminho
   interno do Claude Code. Sempre use `git rev-parse --show-toplevel`.
2. NUNCA exponha valores de variáveis que contenham: password, secret, token,
   key, api_key, credential. Use `[REDACTED]`.
3. SEMPRE execute todos os passos em ordem. Não pule etapas.
4. SEMPRE confirme com o usuário antes de sobrescrever um `.session.md`
   gravado no mesmo dia.
5. O diff completo vai para o arquivo. No chat, exiba apenas a lista de
   arquivos modificados.

## REFERÊNCIAS

- `references/session-template.md` — template do `.session.md`
- `references/briefing-template.md` — template do briefing de retomada
