FROM node:10.21.0

RUN npm install -g envsub

FROM wernight/ngrok

WORKDIR /home/ngrok/.ngrok2/

ARG NGROK_AUTH
ARG NGROK_WEB_PORT
ARG NGROK_API_PORT
ARG NGROK_WS_PORT

COPY ngrok.yml ngrok.yml


