FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install htop -y

EXPOSE 80

CMD [ "ps", "-ef" ]