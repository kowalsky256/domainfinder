FROM golang:1.20-alpine

LABEL maintainer="kowalsky"


# Install packages
RUN \
    apk add --no-cache \
    git \
    make \
    gcc \
    g++ \
    nano \
    curl \
    wget \
    python3 \
    py3-pip \
    zip \
    unzip

RUN pip install requests


# assetfinder configuration
ENV VT_API_KEY "TOKEN VIRUS TOTAL"
ENV FB_APP_ID "Facebook app id"
ENV FB_APP_SECRET "Facebook app secret"


# Findomain configuration
ENV findomain_fb_token="ENTER_TOKEN_HERE"
ENV findomain_virustotal_token="ENTER_TOKEN_HERE"
ENV findomain_securitytrails_token="ENTER_TOKEN_HERE"
ENV findomain_spyse_token="ENTER_TOKEN_HERE"


# TOOLS
RUN mkdir tools \
    mkdir -p /tools/findomain \
    mkidr -p /tools/amass \
    mkdir -p /usr/share/wordlists \
    mkdir -p /root/.config \
    mkdir -p /root/.config/amass \
    mkdir -p /root/.config/subfinder \
    mkdir -p /root/data


WORKDIR /tools/
RUN \
    # Install findomain
    wget --quiet https://github.com/Findomain/Findomain/releases/download/5.1.1/findomain-linux -O /tools/findomain/findomain && \
    chmod +x /tools/findomain/findomain && \
    ln -s /tools/findomain/findomain /usr/bin/findomain && \
    
    # Install assetfinder
    go install github.com/tomnomnom/assetfinder@latest && \
    
    # Install subfinder
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    
    # Install amass 
    go install -v github.com/OWASP/Amass/v3/...@master && \
    #wget https://raw.githubusercontent.com/OWASP/Amass/master/examples/config.ini -P $HOME/.config/amass && \
    
    
    ## Substituto de sublist3r, no funciona muy bien
    #https://github.com/fleetcaptain/Turbolist3r

    ## Install massdns
    git clone https://github.com/blechschmidt/massdns.git /tools/massdns && \
    cd massdns && make && make install && \
    cd /tools && \

    ## Install puredns
    go install github.com/d3mondev/puredns/v2@latest && \
    
    ## Install wordlist commonspeak2 subdomains
    git clone https://github.com/assetnote/commonspeak2-wordlists.git /usr/share/wordlists/commonspeak2-wordlists

COPY amass/config.ini /root/.config/amass/config.ini
COPY subfinder/config.yaml /root/.config/subfinder/config.yaml
COPY subfinder/provider-config.yaml /root/.config/subfinder/provider-config.yaml
#COPY domainfinder.py /root/data/domainfinder.py

# Change workdir
WORKDIR /root/data
