FROM ubuntu:18.04

LABEL maintainer="kowalsky" \
    email="kowalsky.jer@gmail.com"


# Install packages
RUN \
    apt-get update && \
    apt-get install -y \
    python-setuptools \
    python3-setuptools \
    python3-pip \
    chromium-browser \
    git \
    nano \
    curl \
    wget \
    python \
    python3 \
    zip \
    unzip


# Install go
WORKDIR /tmp
RUN \
    wget -q https://go.dev/dl/go1.20.1.linux-amd64.tar.gz -O go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz
ENV GOPATH "/root/go"
ENV PATH "$PATH:/usr/local/go/bin:$GOPATH/bin"

#############################################
##   Variables de entorno para assetfinder ##
#############################################
#API KEY VirusTotal (https://developers.virustotal.com/reference)
ENV VT_API_KEY "aaa"

#API KEY FACEBOOK (https://developers.facebook.com/)
ENV FB_APP_ID "aaa"
ENV FB_APP_SECRET "aaa"



# TOOLS
RUN mkdir tools \
    mkdir -p /tools/findomain \
    mkidr -p /tools/amass \
    mkdir -p /usr/share/wordlists \
    mkdir -p /.config \
    mkdir -p /tools/aquatone


WORKDIR /tools/
RUN \
    # Install findomain
    wget --quiet https://github.com/Findomain/Findomain/releases/download/5.1.1/findomain-linux -O /tools/findomain/findomain && \
    chmod +x /tools/findomain/findomain && \
    ln -s /tools/findomain/findomain /usr/bin/findomain && \
    
    # Install assetfinder (Fa falta configurar la variable d'entorn VT_API_KEY)
    go install github.com/tomnomnom/assetfinder@latest && \
    
    # Install subfinder (Fa falta configurar API KEYS a $HOME/.config/subfinder/provider-config.yaml)
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    
    # Install amass (Fa falta configurar les API KEYs a $HOME/.config/amass/)
    go install -v github.com/OWASP/Amass/v3/...@master && \
    wget https://raw.githubusercontent.com/OWASP/Amass/master/examples/config.ini -P $HOME/.config/amass && \
    
    #Install Sublsit3r (No funciona gaire bé, el deixarem en standby)
    #git clone https://github.com/aboul3la/Sublist3r.git /tools/Sublist3r && \
    #python3 -m pip install -r /tools/Sublist3r/requirements.txt
    ## Aqui esta el subsitut.. pero no funciona gaire bé
    #https://github.com/fleetcaptain/Turbolist3r

    ## Install massdns (Necessari per a puredns)
    git clone https://github.com/blechschmidt/massdns.git /tools/massdns && \
    cd massdns && make && make install && \
    cd /tools && \

    ## Install puredns
    go install github.com/d3mondev/puredns/v2@latest && \
    
    ## Install wordlist commonspeak2 subdomains
    git clone https://github.com/assetnote/commonspeak2-wordlists.git /usr/share/wordlists/commonspeak2-wordlists

    


# Change workdir
WORKDIR /mainData