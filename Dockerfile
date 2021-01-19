FROM misterio92/ci-php-node

ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update

# Install dusk requirements
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update

RUN apt-get install -y libnss3-dev google-chrome-stable mysql-client dnsutils

RUN google-chrome --version

RUN google-chrome-stable --headless --disable-gpu --remote-debugging-port=9222 --no-sandbox http://localhost &

# Install Xdebug
RUN pecl install xdebug
RUN echo 'zend_extension=/usr/lib/php/20190902/xdebug.so' >> /etc/php/7.4/cli/php.ini

# Use node 12
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN source /root/.bashrc && nvm install 12
SHELL ["/bin/bash", "--login", "-c"]

# Install reverse proxy for https to http
RUN npm install -g local-ssl-proxy
