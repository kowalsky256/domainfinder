# domainfinder

## Intallation
```sh
$ docker build -t domainfinderimage .
$ docker run --interactive --tty domainfinderimage
$ docker run --rm -it -v "$PWD":/root/data --name domainfinderdocker domainfinderimage -p [--program] <hackerone> -f [--file] targets.txt
```
