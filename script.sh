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

# Cria a chave SSH se ela ainda não existir na máquina
if [ ! -f "$CHAVE" ]; then
    echo "Gerando uma nova chave SSH..."
    # O parâmetro -N "" cria a chave sem senha (passphrase) para facilitar a automação
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$CHAVE" -N ""
else
    echo "A chave SSH já existe neste computador. Vamos utilizá-la."
fi

# Inicia o agente e adiciona a chave
eval "$(ssh-agent -s)"
ssh-add "$CHAVE"

# Cria a pasta de forma segura e sobrescreve o config (usando > no primeiro comando) para não duplicar linhas
mkdir -p "$HOME/.ssh"
echo "Host *" > "$HOME/.ssh/config"
echo "  AddKeysToAgent yes" >> "$HOME/.ssh/config"
echo "  IdentityFile $CHAVE" >> "$HOME/.ssh/config"

# Ajusta a permissão obrigatoriamente, senão o SSH do Linux recusa a conexão
chmod 600 "$HOME/.ssh/config"

echo "-------------------------"
echo "Sua configuração terminou. Copie a chave abaixo e adicione no GitHub:"
echo ""
cat "${CHAVE}.pub"
echo ""