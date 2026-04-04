#!/bin/bash

echo "Configuração de Git e SSH"
echo "-------------------------"

echo "Digite seu nome para o Git:"
read NOME

echo "Digite seu email para o Git:"
read EMAIL

# Não deixa o usuário continuar se deixar em branco
if [ -z "$NOME" ] || [ -z "$EMAIL" ]; then
    echo "Erro: Você precisa preencher o nome e o email."
    exit 1
fi

# Configura o Git global
git config --global user.name "$NOME"
git config --global user.email "$EMAIL"
echo "Git configurado com sucesso!"

CHAVE="$HOME/.ssh/id_ed25519"


# Inicia o agente e adiciona a chave (aqui ainda vai aparecer mensagens na tela, o que é normal)
eval "$(ssh-agent -s)"
ssh-add "$CHAVE"

# Evolução 3: Cria a pasta de forma segura e sobrescreve o config (usando > no primeiro comando) para não duplicar linhas
mkdir -p "$HOME/.ssh"
echo "Host *" > "$HOME/.ssh/config"
echo "  AddKeysToAgent yes" >> "$HOME/.ssh/config"
echo "  IdentityFile $CHAVE" >> "$HOME/.ssh/config"

# Evolução 4: Ajusta a permissão obrigatoriamente, senão o SSH do Linux recusa a conexão
chmod 600 "$HOME/.ssh/config"

echo "-------------------------"
echo "Sua configuração terminou. Copie a chave abaixo e coloque no GitHub:"
echo ""
cat "${CHAVE}.pub"
echo ""