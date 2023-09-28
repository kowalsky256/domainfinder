# domainfinder

Dockerised script that runs various tools for search subdomains

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
Configure the API keys in file config/amass/config.ini

More info: https://github.com/OWASP/Amass/blob/master/doc/user_guide.md


### subfinder configuration
Configure the API keys in file config/subfinder/provider-config.yaml

More info: https://github.com/projectdiscovery/subfinder

## Usage

```sh
$ git clone https://github.com/kowalsky256/domainfinder.git
$ cd domainfinder

# Configure API KEYs and build image
$ docker build -t domainfinderimage .
```

Search from a single domain:

```sh
$ docker run --rm -it -v "$PWD":/root/data \
    -v "$PWD"/config:/root/.config \
	--name domainfinderdocker domainfinderimage \
	python3 /root/data/domainfinder.py -d <domainTofind>
```

Search from a file with multiple domains:

```sh
$ docker run --rm -it -v "$PWD":/root/data \
    -v "$PWD"/config:/root/.config \
	--name domainfinderdocker domainfinderimage \
	 python3 /root/data/domainfinder.py -f <file>
```

Note: The file must be in the domainfinder folder