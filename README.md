# domainfinder

Script that runs various tools for subdomain search

## API KEYs configuration

### Findomain configuration
Set environment variables in the Dockerfile file

```sh
# Findomain configuration
ENV findomain_fb_token="ENTER_TOKEN_HERE"
ENV findomain_virustotal_token="ENTER_TOKEN_HERE"
ENV findomain_securitytrails_token="ENTER_TOKEN_HERE"
ENV findomain_spyse_token="ENTER_TOKEN_HERE"
```

More info: https://github.com/Findomain/Findomain/blob/master/docs/INSTALLATION.md#access-tokens-configuration


### assetfinder configuration 
Set environment variables in the Dockerfile file

```sh
# assetfinder configuration
ENV VT_API_KEY "TOKEN VIRUS TOTAL"
ENV FB_APP_ID "Facebook app id"
ENV FB_APP_SECRET "Facebook app secret"
```

More info: https://github.com/tomnomnom/assetfinder#implemented


### Amass configuration
Configure the API keys in file amass/config.ini

More info: https://github.com/OWASP/Amass/blob/master/doc/user_guide.md


### subfinder configuration
Configure the API keys in file subfinder/provider-config.yaml

More info: https://github.com/projectdiscovery/subfinder

## Usage
```sh
$ docker build -t domainfinderimage .
$ docker run --rm -it -v "$PWD":/root/data --name domainfinderdocker domainfinderimage python3 /root/data/domainfinder.py -d nextail.co
```