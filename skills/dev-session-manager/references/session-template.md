# Sessão de Desenvolvimento

> Gerado automaticamente pelo Dev Session Manager.
> Não edite manualmente — use os comandos "encerrar sessão" / "retomar o projeto".

---

## Identificação

| Campo | Valor |
|---|---|
| Projeto | {{PROJETO}} |
| Caminho local | {{CAMINHO_RAIZ}} |
| Data/hora de encerramento | {{DATA_HORA}} |
| Máquina de origem | {{HOSTNAME}} |

---

## Estado do Git

| Campo | Valor |
|---|---|
| Branch ativa | {{BRANCH}} |
| Último commit | {{ULTIMO_COMMIT_HASH}} — {{ULTIMO_COMMIT_MSG}} |
| Arquivos modificados | {{CONTAGEM_MODIFICADOS}} arquivo(s) |
| Stashes pendentes | {{CONTAGEM_STASHES}} |

### Arquivos com alterações

```
{{GIT_STATUS_SHORT}}
```

### Histórico recente (últimos 10 commits)

```
{{GIT_LOG_ONELINE}}
```

### Diff completo (HEAD)

```diff
{{GIT_DIFF_HEAD}}
```

### Stashes pendentes

```
{{GIT_STASH_LIST}}
```

---

## Ambiente

| Ferramenta | Versão |
|---|---|
| Node.js | {{NODE_VERSION}} |
| Java | {{JAVA_VERSION}} |
| Python | {{PYTHON_VERSION}} |

### Portas em uso no momento do encerramento

```
{{PORTAS_ATIVAS}}
```

### Variáveis de ambiente relevantes (chaves apenas)

```
{{ENV_KEYS}}
```

---

## Contexto de Trabalho

### Tarefa em andamento

{{TAREFA_EM_ANDAMENTO}}

### Próximo passo planejado

{{PROXIMO_PASSO}}

---

## Backlog e Pendências

> Liste abaixo os itens pendentes, ordenados por prioridade.
> Formato: `- [ ] [PRIORIDADE] Descrição`

{{BACKLOG}}

---

## Decisões de Arquitetura

> Decisões tomadas nesta sessão que afetam a estrutura do sistema.
> Formato: `- **Decisão:** ... | **Motivo:** ... | **Impacto:** ...`

{{DECISOES_ARQUITETURA}}

---

## Bugs e Erros em Aberto

> Problemas conhecidos que não estão no código e não foram resolvidos.
> Formato: `- **[SEVERIDADE]** Descrição — Contexto/onde ocorre`

{{BUGS_ABERTOS}}

---

## Changelog desta sessão

> O que foi feito nesta sessão de trabalho.

{{CHANGELOG_SESSAO}}

---

## Notas livres

{{NOTAS_LIVRES}}
