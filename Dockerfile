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
    git \
    tar \
    unzip

# Cria diretórios para os JDKs e Maven
RUN mkdir -p /usr/local/jdk && mkdir -p /usr/local/maven

# Copia os arquivos de instalação do JDK para o contêiner
COPY jdk_tar_files/jdk-10.0.1_linux-x64_bin.tar.gz /tmp/
COPY jdk_tar_files/jdk-14.0.2_linux-x64_bin.tar.gz /tmp/
COPY jdk_tar_files/jdk-21_linux-x64_bin.tar.gz /tmp/

# Instala o JDK 10.0.1
RUN tar -xzf /tmp/jdk-10.0.1_linux-x64_bin.tar.gz -C /usr/local/jdk && \
    update-alternatives --install /usr/bin/java java /usr/local/jdk/jdk-10.0.1/bin/java 1 && \
    update-alternatives --install /usr/bin/javac javac /usr/local/jdk/jdk-10.0.1/bin/javac 1

# Instala o JDK 14.0.2
RUN tar -xzf /tmp/jdk-14.0.2_linux-x64_bin.tar.gz -C /usr/local/jdk && \
    update-alternatives --install /usr/bin/java java /usr/local/jdk/jdk-14.0.2/bin/java 2 && \
    update-alternatives --install /usr/bin/javac javac /usr/local/jdk/jdk-14.0.2/bin/javac 2

# Instala o JDK 21
RUN tar -xzf /tmp/jdk-21_linux-x64_bin.tar.gz -C /usr/local/jdk && \
    update-alternatives --install /usr/bin/java java /usr/local/jdk/jdk-21.0.3/bin/java 3 && \
    update-alternatives --install /usr/bin/javac javac /usr/local/jdk/jdk-21.0.3/bin/javac 3

# Copia os arquivos de instalação do Maven para o contêiner
COPY maven_tar_files/apache-maven-3.8.6-bin.tar.gz /tmp/
COPY maven_tar_files/apache-maven-3.9.2-bin.tar.gz /tmp/

# Instala o Maven 3.8.6
RUN tar -xzf /tmp/apache-maven-3.8.6-bin.tar.gz -C /usr/local/maven && \
    ln -s /usr/local/maven/apache-maven-3.8.6/bin/mvn /usr/bin/mvn3.8.6

# Instala o Maven 3.9.2
RUN tar -xzf /tmp/apache-maven-3.9.2-bin.tar.gz -C /usr/local/maven && \
    ln -s /usr/local/maven/apache-maven-3.9.2/bin/mvn /usr/bin/mvn3.9.2

# Instala o ant
ENV ANT_VERSION=1.10.14
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
        && tar xvfvz apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt \
        && ln -sfn /opt/apache-ant-${ANT_VERSION} /opt/ant \
        && sh -c 'echo ANT_HOME=/opt/ant >> /etc/environment' \
        && ln -sfn /opt/ant/bin/ant /usr/bin/ant \
        && rm apache-ant-${ANT_VERSION}-bin.tar.gz


WORKDIR /home

# Copia os diretórios MAVGCL, MAVBase, mavutils e mavcom para o diretório /home no contêiner
COPY MAVGCL /home/MAVGCL
COPY MAVBase /home/MAVBase
COPY mavutils /home/mavutils
COPY mavcom /home/mavcom

# Comando padrão ao iniciar o container
CMD ["bash"]