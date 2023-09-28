#!/usr/bin/python3
import os
import requests
import sys
import getopt
import json 

IS_FILE=False
CONFIG_FILE_AMASS="$HOME/.config/amass/config.ini"
AMASS_OUTPUT="subdomains-amass.txt"
FINDOMAIN_OUTPUT="subdomains-findomain.txt"
CRTSH_OUTPUT="subdomains-crtsh.txt"
ASSETFINDER_OUTPUT="subdomains-assetfinder.txt"
SUBFINDER_OUTPUT="subdomains-subfinder.txt"
BRUTE_FORCE_OUTPUT="subdomains-bruteforce.txt"
WORDLIST="/usr/share/wordlists/commonspeak2-wordlists/subdomains/subdomains.txt"

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def showHelp():
    print("use: python domainfinder.py [-d | -f]")
    print("  Options:")
    print("	   -d --domain  domain")
    print("	   -f --file    input file with list of domains")
    print("  Examples:")
    print("     ./domaindinder.py -d domain.com")
    print("     ./domaindinder.py -f domains.txt")


## Sublist3r often has a dirty output. This function cleans the file.
# Ex: socialize.demorgen.be<BR>www.socialize.demorgen.be
# We must: <BR> --> replace --> \n
def clearTheFile(file):
	f = open(file,'r')
	filedata = f.read()
	f.close()

	newdata = filedata.replace("<BR>","\n")

	f = open(file,'w')
	f.write(newdata)
	f.close()


def getDomain(argv):
    try:
      opts, args = getopt.getopt(argv,"h:d:f:",["domain","file","help"])
    except getopt.GetoptError:
      showHelp()
      sys.exit(2)
    for opt, arg in opts:
      if opt == '-h':
         showHelp()
         sys.exit()
      elif opt in ("-d", "--domain"):
        return arg
      elif opt in ("-f", "--file"):
      	global IS_FILE
      	IS_FILE=True
      	return arg


def searchfindomain(domain):
	os.system("findomain -t {0} -u {1}".format(domain, FINDOMAIN_OUTPUT))


def searchAssetFinder(domain):
	os.system("assetfinder -subs-only {0} >> {1}".format(domain, ASSETFINDER_OUTPUT))


def searchBruteForce(domain):
	os.system("echo '8.8.8.8' >> resolvers.txt")
	os.system("echo '8.8.4.4' >> resolvers.txt")
	os.system("puredns bruteforce {0} {1} --write {2} --resolvers resolvers.txt".format(WORDLIST, domain, BRUTE_FORCE_OUTPUT))
	os.system("rm -Rf resolvers.txt")

def searchCrtshByDomain(domain):
	try:
		req = requests.get("https://crt.sh/?q=%.{d}&output=json".format(d=domain))
		json_data = json.loads(req.text)
		f = open(CRTSH_OUTPUT, "a")

		for (key,value) in enumerate(json_data):
			name_value=value['name_value']
			name_value=name_value.replace('\n' , ' ')
			name_value=name_value.split(' ')

			for name in name_value:
				f.write(name + "\n")

		f.close()
	except:
		print (f"{bcolors.FAIL}[-] ERROR reading response from crt.sh{bcolors.ENDC}")



def searchAmass(domain):
	os.system("amass enum -passive -d {0} -o {1} --config {2}".format(domain, AMASS_OUTPUT, CONFIG_FILE_AMASS))

def searchSubfinder(domain):
	os.system("subfinder -all -d {0} -o {1}".format(domain, SUBFINDER_OUTPUT))




# handler of all calls
def searchSubdomain(domain):
	outputFile=""+domain+".txt"

	print (f"{bcolors.WARNING}* Searching ", domain ,f"{bcolors.ENDC}")

	print (f"{bcolors.HEADER}[+] Searching with findomain{bcolors.ENDC}")
	searchfindomain(domain)

	print (f"{bcolors.HEADER}[+] Searching with assetfinder{bcolors.ENDC}")
	searchAssetFinder(domain)

	print (f"{bcolors.HEADER}[+] Searching with subfinder{bcolors.ENDC}")
	searchSubfinder(domain)

	print (f"{bcolors.HEADER}[+] Searching in crt.sh {bcolors.ENDC}")
	searchCrtshByDomain(domain)

	print (f"{bcolors.HEADER}[+] Searching with amass {bcolors.ENDC}")
	searchAmass(domain)
	
	print (f"{bcolors.HEADER}[+] Searching with brute force {bcolors.ENDC}")
	searchBruteForce(domain)

	os.system("cat {0} {1} {2} {3} {4} {5} | sort -u > ".format(AMASS_OUTPUT, CRTSH_OUTPUT, FINDOMAIN_OUTPUT, ASSETFINDER_OUTPUT, SUBFINDER_OUTPUT, BRUTE_FORCE_OUTPUT) + outputFile)
	os.system("rm {0} {1} {2} {3} {4} {5}".format(AMASS_OUTPUT, CRTSH_OUTPUT, ASSETFINDER_OUTPUT, FINDOMAIN_OUTPUT, SUBFINDER_OUTPUT, BRUTE_FORCE_OUTPUT))

	clearTheFile(outputFile)

	print (f"{bcolors.WARNING}* Results are stored in "+outputFile+f"{bcolors.ENDC}")




def searchSubdomainsFromFile(file):
	with open(file) as fp:
		for line in fp:
			line=line.rstrip('\n')
			searchSubdomain(line)
			



def main(argv):
    input_source=getDomain(argv)

    if IS_FILE:
    	searchSubdomainsFromFile(input_source)
    else:
    	searchSubdomain(input_source)
   
    print (f"{bcolors.WARNING}* DON'T FORGET: You can try to find more scope of company by trying crt.sh with UO or O in the following way:{bcolors.ENDC}")
    print (f"{bcolors.FAIL}b=$(curl -ks \"https://crt.sh/?O=<organitzation>\" | grep -Po \"(?<=\\?id=).*(?=\\\")\"); for i in $b; do curl -ks \"https://crt.sh/?id=$i\" | grep -Po \"(?<=DNS:).*?(?=<BR)\"; done {bcolors.ENDC}")

if __name__ == "__main__":
   main(sys.argv[1:])

