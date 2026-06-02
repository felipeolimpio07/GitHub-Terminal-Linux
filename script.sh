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

# ==========================================
# NOVAS MELHORIAS DE AUTOMAÇÃO DE CLONE/PULL
# ==========================================

echo "⚠️ IMPORTANTE: Vá até o GitHub -> Settings -> SSH and GPG keys e cole a chave acima."
# O script pausa aqui até você apertar ENTER
read -p "Pressione [ENTER] APÓS ter adicionado a chave no GitHub para continuarmos..."

echo ""
echo "Testando a conexão com o GitHub..."
# ssh -T testa a conexão e o grep filtra a mensagem de sucesso para não poluir muito a tela
ssh -T git@github.com 2>&1 | grep -q "You've successfully authenticated"
if [ $? -eq 0 ]; then
    echo "✅ Conexão com GitHub estabelecida com sucesso!"
else
    echo "⚠️ Aviso: O teste de conexão não retornou a mensagem de sucesso esperada. O clone pode falhar."
fi

echo ""
echo "Deseja clonar um repositório novo ou atualizar um existente agora? (s/n)"
read RESP

if [ "$RESP" = "s" ] || [ "$RESP" = "S" ]; then
    echo "Cole o link SSH do repositório (ex: git@github.com:usuario/projeto.git):"
    read LINK_REPO

    if [ -n "$LINK_REPO" ]; then
        # O comando basename extrai apenas o nome do projeto (ex: de 'git@github.com:user/projeto.git' ele pega 'projeto')
        NOME_PASTA=$(basename -s .git "$LINK_REPO")

        # Verifica se um diretório com o nome do projeto já existe
        if [ -d "$NOME_PASTA" ]; then
            echo "O diretório '$NOME_PASTA' já existe. Atualizando com 'git pull'..."
            cd "$NOME_PASTA" || exit
            git pull
            cd ..
            echo "✅ Projeto atualizado com sucesso!"
        else
            echo "O diretório '$NOME_PASTA' não foi encontrado localmente. Iniciando o clone..."
            git clone "$LINK_REPO"
            echo "✅ Projeto clonado com sucesso!"
        fi
    else
        echo "Nenhum link foi inserido. Saindo."
    fi
else
    echo "Tudo pronto! Setup finalizado."
fi
