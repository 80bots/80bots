FROM node
LABEL Description="80bots React App"

# Environment variables
ENV HOME /root
ENV APP_ROOT /var/www/app

COPY ./.ssh $HOME/.ssh

RUN chmod 400 $HOME/.ssh/id_rsa
RUN touch $HOME/.ssh/known_hosts && ssh-keyscan github.com >> $HOME/.ssh/known_hosts

# TODO: Move all the following code into .sh command in order to make static Image
# Clone existing application contents
RUN git clone git@github.com:80bots/saas-next.js.git $APP_ROOT && cd $APP_ROOT && git pull

# Setup env file
COPY .env $APP_ROOT/.env

# Install composer dependencies
RUN cd $APP_ROOT && yarn

WORKDIR $APP_ROOT

RUN yarn build

CMD yarn start