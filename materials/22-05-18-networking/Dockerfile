FROM ubuntu

VOLUME        ["C:/", "/reid_networking"]
WORKDIR "/reid_networking"

RUN apt-get update 
RUN apt-get install -y python3

EXPOSE 80

CMD exec /bin/bash -c "sleep 1000000"
