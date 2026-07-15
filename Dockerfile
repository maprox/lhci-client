# Analog of patrickhulce/lhci-client, but:
# - Node 24 LTS (lighthouse@13 needs >= 22.19)
# - @lhci/cli@0.15.1 with npm override → lighthouse@13.4.0
FROM node:24-bookworm-slim

LABEL org.opencontainers.image.title="maprox/lhci-client"
LABEL org.opencontainers.image.description="LHCI client with Lighthouse 13.4.0"
LABEL org.opencontainers.image.authors="box@sunsay.ru"

ENV PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

RUN apt-get update --fix-missing \
 && apt-get -y upgrade \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      gnupg \
      wget \
 && mkdir -p /etc/apt/keyrings \
 && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
      | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
 && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
      > /etc/apt/sources.list.d/google-chrome.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends google-chrome-stable \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/maprox-lhci-client
COPY package.json ./
RUN npm install \
 && ln -sf /opt/maprox-lhci-client/node_modules/.bin/lhci /usr/local/bin/lhci \
 && ln -sf /opt/maprox-lhci-client/node_modules/.bin/lighthouse /usr/local/bin/lighthouse \
 && npm install -g puppeteer \
 && node -p "require('lighthouse/package.json').version" \
 && lhci --version \
 && lighthouse --version

RUN groupadd --system lhci \
 && useradd --system --create-home --gid lhci lhci \
 && mkdir -p /home/lhci/reports \
 && chown -R lhci:lhci /home/lhci

USER lhci
WORKDIR /home/lhci/reports
RUN npm link puppeteer

CMD ["lhci", "--help"]
