docker build -t reidtest .

# Powershell only:
docker run --privileged --rm -ti -p 8080:8080 -v c:/Users/Reid/Desktop/Docker:/reid_networking reidtest bash

# Git-Bash only:
winpty docker run --privileged --rm -ti -p 8080:8080 -v c:/Users/Reid/Desktop/Docker:/reid_networking reidtest bash
