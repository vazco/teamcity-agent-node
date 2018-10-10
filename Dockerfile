FROM jetbrains/teamcity-minimal-agent:latest
MAINTAINER Maciej Stasieluk <maciej.stasieluk@vazco.eu>

# Install dependecies
RUN set -x && \
    apt-get update -y && \
    apt-get install -y \
        # Basic stuff
        curl \
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

# Install SonarQube scanner
ARG SONAR_SCANNER_VERSION=3.2.0.1227
RUN set -x && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip -P /tmp && \
    unzip /tmp/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip -d /usr/local && \
    ln -s /usr/local/sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Clean excessive files
RUN set -x && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/*

# Healthcheck and version stats
RUN set -x && \
    node --version && \
    npm --version && \
    sonar-scanner --version && \
    java -version