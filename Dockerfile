FROM ubuntu:24.04

# Update the package list
RUN apt-get update

# Configure timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Prague
RUN apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get install -y \
    curl \
    sudo \
    git \
    gh \
    openssh-server \
    openjdk-21-jdk \
    postgresql

# Install nvm, Node.js and pnpm
ENV NVM_VERSION=0.40.1
ENV NODE_VERSION=22.13.1
ENV PNPM_VERSION=10.2.0
ENV NVM_DIR=/usr/local/nvm

RUN mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install ${NODE_VERSION} && \
    npm install -g pnpm@${PNPM_VERSION}

# Create a Linux user 'dev' with password 'dev' able to sudo
RUN useradd -m -s /bin/bash -G sudo dev && \
    echo "dev:dev" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add node and pnpm to 'dev' user's PATH
USER dev
RUN echo "export NVM_DIR=$NVM_DIR" >> /home/dev/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/dev/.bashrc && \
    echo "export PATH=\"\$NVM_DIR/versions/node/v$NODE_VERSION/bin:\$PATH\"" >> /home/dev/.bashrc

# Create a PostgreSQL user 'dev' with password 'dev'
USER root
RUN service postgresql start && \
    su - postgres -c "psql -c \"CREATE USER dev WITH PASSWORD 'dev';\" && \
                      psql -c \"ALTER USER dev CREATEDB;\" && \
                      psql -c \"ALTER USER dev CREATEROLE;\""

EXPOSE 22 5173 5432 8080

CMD ["/bin/bash", "-c", "service ssh start && service postgresql start && su - dev"]
