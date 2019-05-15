FROM jetbrains/teamcity-minimal-agent:latest
LABEL maintainer="Maciej Stasieluk <maciej.stasieluk@vazco.eu>"

# Install dependecies
RUN set -x && \
    apt-get update -y && \
    apt-get install -y \
        # Basic stuff
        bzip2 \
        curl \
        git \
        tar \
        unzip \
        wget \
        # bcrypt and friends
        bcrypt \
        make \
        g++ \
        python \
        # Chromium requirements
        gconf-service \
        libasound2 \
        libatk1.0-0 \
        libc6 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libexpat1 \
        libfontconfig1 \
        libgcc1 \
        libgconf-2-4 \
        libgdk-pixbuf2.0-0 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libstdc++6 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        ca-certificates \
        fonts-liberation \
        libappindicator1 \
        libnss3 \
        lsb-release \
        xdg-utils

# Install node 10.x and npm 6.x
RUN set -x && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@6

# Install latest Meteor version
ENV METEOR_ALLOW_SUPERUSER 1
RUN set -x && curl https://install.meteor.com/ | sh

# Fix for missing locales (https://github.com/meteor/meteor/issues/4019)
RUN echo "export LC_ALL=C.UTF-8" >> ~/.bashrc

# Install SonarQube scanner
ARG SONAR_SCANNER_VERSION=3.3.0.1492
RUN set -x && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip -P /tmp && \
    unzip /tmp/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip -d /usr/local && \
    ln -s /usr/local/sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Install Docker CLI
ARG DOCKER_VERSION=18.06.3-ce
RUN cd /tmp && \
    set -x  && \
    wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar -xf docker-${DOCKER_VERSION}.tgz && \
    cp ./docker/docker /usr/local/bin

# Clean excessive files
RUN set -x && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/*

# Environment variables
ENV JAVA_TOOL_OPTIONS="-XX:+UnlockExperimentalVMOptions"

# Healthcheck and version stats
RUN set -x && \
    git --version && \
    node --version && \
    npm --version && \
    meteor --version && \
    java -version && \
    sonar-scanner --version && \
    docker --version
