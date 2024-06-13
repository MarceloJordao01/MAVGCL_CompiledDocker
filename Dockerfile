# Usa a imagem base do Ubuntu 20.04
FROM ubuntu:20.04

# Define o ambiente como não interativo para evitar prompts de confirmação durante instalações
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza o sistema e instala algumas dependências básicas
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    curl \
    wget \
    vim \
    git 

WORKDIR /home

# Comando padrão ao iniciar o container
CMD ["bash"]