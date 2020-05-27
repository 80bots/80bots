FROM node

# Setup starup script
RUN mkdir /var/src
COPY ./bin/start.sh /var/src/start.sh
RUN chmod 700 /var/src/start.sh

WORKDIR /var/src/

CMD ["./start.sh"]