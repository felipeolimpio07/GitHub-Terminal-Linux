Passo a passo para realizar a sincronização

 
1° Passo * Copie o código do Script abaixo e cole no seu editor de texto.

2° Passo * Salve o arquivo com o nome script.sh.

3° Passo * Abra o seu terminal (CTRL + ALT + T) e navegue até a pasta onde você salvou o script.

4° Passo * No terminal, digite o comando chmod +x script.sh. Esse código vai dar permissão de execução ao seu script.

5° Passo

Rode o script no terminal usando o comando ./script.sh.

6° Passo * Digite seu nome de usuário quando o script pedir.

7° Passo * Digite seu e-mail de acesso ao GitHub.

8° Passo * O terminal vai exibir uma chave abaixo da frase "Sua configuração terminou. Copie a chave abaixo e coloque no GitHub:". Copie todo o bloco de texto que começa com ssh-ed25519.

9° Passo * Abra o seu GitHub no navegador. Vá na sua foto de perfil > Settings > SSH and GPG keys.

10° Passo * Clique no botão New SSH key. Dê um título para ela (ex: "Meu Notebook"), cole o código copiado no 8° passo dentro do campo "Key" e clique no botão verde Add SSH key.

11° Passo * Para ter certeza de que está tudo configurado e sincronizado, volte ao terminal e rode o comando:
ssh -T git@github.com

Se aparecer a mensagem "Hi SEUNOMEDEUSUARIO! You've successfully authenticated, but GitHub does not provide shell access.", significa que seu terminal está perfeitamente configurado!
