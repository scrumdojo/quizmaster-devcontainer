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
    sudo \
    git \
    gh \
    openssh-server \
    openjdk-21-jdk \
    postgresql

# Install Node.js 22 LTS
RUN wget -qO- https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Create a Linux user 'dev' with password 'dev' able to sudo
RUN useradd -m -s /bin/bash -G sudo dev && \
    echo "dev:dev" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install pnpm
USER dev
RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash - 

# Create a PostgreSQL user 'dev' with password 'dev'
USER root
RUN service postgresql start && \
    su - postgres -c "psql -c \"CREATE USER dev WITH PASSWORD 'dev';\" && \
                      psql -c \"ALTER USER dev CREATEDB;\" && \
                      psql -c \"ALTER USER dev CREATEROLE;\""

EXPOSE 22 5173 5432 8080

CMD ["/bin/bash", "-c", "service ssh start && service postgresql start && su - dev"]
