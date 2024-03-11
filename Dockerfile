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
    openssl \
    unzip

RUN pip install requests --break-system-packages


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
    mkdir -p /usr/share/wordlists \
    mkdir -p /root/.config \
    mkdir -p /root/data


WORKDIR /tools/

RUN \
    # Install findomain
    curl -sLO https://github.com/Findomain/Findomain/releases/latest/download/findomain-linux.zip && \
	unzip findomain-linux.zip && \
	rm findomain-linux.zip && \
	mv findomain /usr/bin/ && \
	chmod +x /usr/bin/findomain
    
    # Install assetfinder
RUN go install github.com/tomnomnom/assetfinder@latest
    
    # Install subfinder
RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    
    # Install amass version 3 latest
RUN go install -v github.com/owasp-amass/amass/v3/...@master

        
    ## Install massdns
RUN git clone https://github.com/blechschmidt/massdns.git /tools/massdns && \
    cd massdns && make && make install && \
    cd /tools

    ## Install puredns
RUN go install github.com/d3mondev/puredns/v2@latest
    
    ## Install wordlist commonspeak2 subdomains
RUN git clone https://github.com/assetnote/commonspeak2-wordlists.git /usr/share/wordlists/commonspeak2-wordlists


# Change workdir
WORKDIR /root/data
