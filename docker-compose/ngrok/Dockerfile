FROM wernight/ngrok

USER root

RUN set -x && apk add --update nodejs npm

WORKDIR /home/ngrok/.ngrok2

ARG NGROK_AUTH
ARG WEB_SUBDOMAIN
ARG API_SUBDOMAIN
ARG WS_SUBDOMAIN

RUN npm install -g envsub

COPY ngrok.template.yml /home/ngrok/.ngrok2

RUN envsub \
    --env NGROK_AUTH=${NGROK_AUTH} \
    --env WEB_SUBDOMAIN=${WEB_SUBDOMAIN} \
    --env API_SUBDOMAIN=${API_SUBDOMAIN} \
    --env WS_SUBDOMAIN=${WS_SUBDOMAIN} \
    --system /home/ngrok/.ngrok2/ngrok.template.yml /home/ngrok/.ngrok2/ngrok.yml

RUN cat ./ngrok.yml
CMD ngrok.yml start --force

USER ngrok


