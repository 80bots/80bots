FROM wernight/ngrok

USER root

RUN set -x && apk add --update nodejs npm

WORKDIR /home/ngrok/.ngrok2

ARG NGROK_AUTH
ARG FRONTEND_SUBDOMAIN
ARG BACKEND_SUBDOMAIN
ARG WS_SUBDOMAIN

RUN npm install -g envsub

COPY ngrok.template.yml /home/ngrok/.ngrok2

RUN envsub \
    --env NGROK_AUTH=${NGROK_AUTH} \
    --env FRONTEND_SUBDOMAIN=${FRONTEND_SUBDOMAIN} \
    --env BACKEND_SUBDOMAIN=${BACKEND_SUBDOMAIN} \
    --env WS_SUBDOMAIN=${WS_SUBDOMAIN} \
    --system /home/ngrok/.ngrok2/ngrok.template.yml /home/ngrok/.ngrok2/ngrok.yml

RUN cat ./ngrok.yml
CMD ngrok.yml start --force

USER ngrok


