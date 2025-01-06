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

# Create a Linux user 'dev' with password 'dev' able to sudo
RUN useradd -m -s /bin/bash -G sudo dev && \
    echo "dev:dev" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Clone the Quizmaster repository
# Install pnpm, Node.js & Playwright dependencies (browsers)
USER dev
WORKDIR /home/dev
RUN git clone https://github.com/scrumdojo/quizmaster && \
    cd quizmaster/backend && \
    ./gradlew assembleFrontend

# Add pnpm & Node.js to PATH
RUN echo 'export PATH="$HOME/quizmaster/frontend/node/bin:$PATH"' > ~/.bashrc

# Create a PostgreSQL user 'dev' with password 'dev' & create Quizmaster database
USER root
RUN service postgresql start && \
    su - postgres -c "psql -c \"CREATE USER dev WITH PASSWORD 'dev';\" && \
                      psql -c \"ALTER USER dev CREATEDB;\" && \
                      psql -c \"ALTER USER dev CREATEROLE;\"" && \
    su - dev -c "psql -d postgres -f /home/dev/quizmaster/backend/create_db.sql"

EXPOSE 22 5173 5432 8080

CMD ["/bin/bash", "-c", "service ssh start && service postgresql start && su - dev"]
