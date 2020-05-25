FROM node

# Environment variables
ENV HOME /root

# Setup GIT ssh key
COPY ./.ssh $HOME/.ssh

RUN chmod 400 $HOME/.ssh/id_rsa
RUN touch $HOME/.ssh/known_hosts && ssh-keyscan github.com >> $HOME/.ssh/known_hosts

# Setup starup script
COPY ./bin/start.sh /var/www/start.sh
RUN chmod 700 /var/www/*.sh

WORKDIR /var/www