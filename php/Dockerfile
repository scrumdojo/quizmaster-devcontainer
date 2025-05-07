FROM ubuntu:24.04

# Update the package list
RUN apt-get update

# Configure timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Prague
RUN apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Set locales
RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Add the Ondřej PHP PPA for PHP 8.2 packages and update package lists
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php -y && apt-get update

# Install packages
RUN apt-get install -y \
    sudo \
    git \
    gh \
    openssh-server \
    php8.2 \
    php8.2-cli \
    php8.2-common \
    php8.2-intl \
    php8.2-pgsql \
    php8.2-xml \
    php8.2-mbstring \
    composer \
    postgresql

# Install Node.js 22 LTS
RUN wget -qO- https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Install pnpm
RUN npm install -g pnpm

# Create 'quizmaster' PostgreSQL user and 'quizmaster' database
RUN service postgresql start && \
    su - postgres -c "psql -c \"CREATE USER quizmaster WITH PASSWORD 'quizmaster';\" && \
                      psql -c \"CREATE DATABASE quizmaster;\" && \
                      psql -c \"GRANT ALL PRIVILEGES ON DATABASE quizmaster TO quizmaster;\" && \
                      psql -d quizmaster -c \"GRANT ALL PRIVILEGES ON SCHEMA public TO quizmaster;\""

# Create 'vscode' user to match Codespaces conventions
RUN groupadd vscode && \
    useradd -m -s /bin/bash -G sudo -g vscode vscode && \
    echo "vscode:vscode" | chpasswd && \
    echo "vscode ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Entrypoint script to start SSH and PostgreSQL and interactive shell as 'vscode' user
COPY sh/interactive.sh /usr/local/bin/interactive.sh
RUN chmod +x /usr/local/bin/interactive.sh

COPY sh/services.sh /usr/local/bin/services.sh
RUN chmod +x /usr/local/bin/services.sh

EXPOSE 22 3333 5173 5432 8080

USER vscode
CMD ["/usr/local/bin/interactive.sh"]
