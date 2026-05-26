# Briefing de Retomada — {{PROJETO}}

> Sessão gravada em {{DATA_HORA_SESSAO}} | Branch: `{{BRANCH}}`
> {{ALERTA_DIVERGENCIA}}

---

## Onde você parou

**Tarefa em andamento:**
{{TAREFA_EM_ANDAMENTO}}

**Próximo passo planejado:**
{{PROXIMO_PASSO}}

---

## Estado do repositório

{{#SE_ESTADO_LIMPO}}
Repositório limpo — sem alterações locais desde o encerramento.
{{/SE_ESTADO_LIMPO}}

{{#SE_ESTADO_DIVERGENTE}}
> Atenção: o estado atual difere do que foi salvo.

Arquivos com alterações locais:
```
{{GIT_STATUS_ATUAL}}
```
{{/SE_ESTADO_DIVERGENTE}}

Último commit registrado:
`{{ULTIMO_COMMIT_HASH}}` — {{ULTIMO_COMMIT_MSG}}

{{#SE_STASHES}}
Stashes pendentes:
```
{{STASH_LIST}}
```
{{/SE_STASHES}}

---

## Pendências prioritárias

{{BACKLOG_FORMATADO}}

---

## Bugs em aberto

{{BUGS_FORMATADO}}

---

## Decisões de arquitetura vigentes

{{DECISOES_FORMATADAS}}

---

## Para começar agora

Execute na ordem:

```bash
# 1. Verificar estado do repositório
git status

# 2. (se houver stashes) Verificar stash antes de qualquer mudança
git stash list

# 3. Instalar/atualizar dependências se necessário
# npm install | mvn install | pip install -r requirements.txt

# 4. Subir o ambiente de desenvolvimento
# [comando de start do projeto — ajuste conforme necessário]
```

Próximo passo: **{{PROXIMO_PASSO}}**

---

*Sessão carregada pelo Dev Session Manager.*
