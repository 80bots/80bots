Brief information: 

This application is developed for simple local deployment of 80bots application architecture that includes the following repositories:

1. Laravel APP (https://github.com/80bots/saas-laravel) is intended for:
    - API to interact with functional options;
    - Laravel Schedule to perform routine tasks such as sync and data update
    - Demonized Queue worker based on Supervisor for processing a queue of tasks set
    - Broadcasting - for notifying subscribers about events (notification via WebSockets)
    - Interaction with Primary database based on MySQL
    - Bots (instances) management (Start, Stop, Terminate etc.)
2. NextJS APP (https://github.com/80bots/saas-next.js) is intended for: 
    - convenient providing data related to bots
    - interaction with API for managing data and services 
    - reviewing info about users and everything related
    - configuring custom scripts and parameters of launching bots and instances on which they will be installed. 
3. Bots scripts (https://github.com/80bots/puppeteer), are intended for: 
    - various parsing 
    - gathering info and providing it in special formats. 

#Environment variables:

#### BUILDER GIT CONFIG
- `GIT_NAME` - variable that will be used under Git configuration (git config user.name $GIT_USER)
- `GIT_EMAIL` - variable that will be used under Git configuration (git config user.name $GIT_USER)

It is important to set these parameters in order to commit changes from the local environment correctly.

#### PROXY SERVER CONFIG
- `DOCKER_WEB_SERVER_HOST` - NextJS host, default: localhost (Custom usage example: 80bots.loc).
- `DOCKER_WEB_SERVER_PORT` - NextJS port, default: 80 (Custom usage example: 80)
- `DOCKER_API_SERVER_HOST` - API host, default: localhost (Custom usage example: api.80bots.loc)
- `DOCKER_API_SERVER_PORT` - API host, default: 8080 (Custom usage example: 80)
- `DOCKER_SOCKET_SERVER_HOST` - WS host, default: localhost (Custom usage example: ws.80bots.loc)
- `DOCKER_SOCKET_SERVER_PORT` - WS post, default: 6001 (Custom usage example: 80)

If you consider to use your own custom hosts and ports please make sure you've added them to `/etc/hosts`

#### MYSQL SERVER CONFIG:

- `DOCKER_MYSQL_ROOT_PASSWORD` - Password to create on the service startup phase for the `root` user, default: root
- `DOCKER_MYSQL_USER` - Additional non root user which will be created on the service startup phase, default: user
- `DOCKER_MYSQL_PASSWORD` - Additional user's password, default: user
- `DOCKER_MYSQL_DATABASE` - Default database name which will be created if not exists on startup phase, default: user

#### WEB APP CONFIG
- `API_URL` - The public accessible API server url (baseUrl), default: http://localhost:8080/api
- `SOCKET_URL` - The public accessible WebSockets server url, default: http://localhost:6001
- `SOCKET_AUTH_URL` - The WS auth host, default: http://localhost:8080
- `STRIPE_PUBLIC_KEY` - Stripe Public Key, default: none
- `GOOGLE_CLIENT_ID` - Google client id, default: none
- `FACEBOOK_CLIENT_ID` - Facebook client id, default: none
- `SENTRY_DSN_WEB` - Sentry DSN, default: none

##### LARAVEL APP CONFIG

- `APP_NAME` - Name of the Laravel App, default: 80bots
- `APP_ENV` - Environment, default: local
- `APP_DEBUG` - Debug enabled, default: false (see more on https://laravel.com/docs)
- `APP_KEY` - App secret key. Important! If the application key is not set, your user sessions and other encrypted data will not be secure!
- `APP_URL` - The public accessible App server url, default: http://localhost:8080 (Based on PROXY SERVER CONFIG section)
- `REACT_URL` - The public accessible Web app server url, default: http://localhost (Based on PROXY SERVER CONFIG section)
- `LOG_CHANNEL` - The log channel, default: stack
- `BROADCAST_DRIVER` - Broadcast driver, default: redis. Warning! Changing of this parameter could affect the app stability and functionality
- `QUEUE_CONNECTION` - Broadcast driver, default: redis. Warning! Changing of this parameter could affect the app stability and functionality
- `CACHE_DRIVER` - Cache driver, default: file
- `SESSION_DRIVER` - Session driver, default: file
- `SESSION_LIFETIME` - Session lifetime, default 120
- `DB_CONNECTION` - DB driver (connection), default: mysql. Warning! Changing of this parameter could affect the app stability and functionality
- `DB_HOST` - DB host, default: mysql. The default value uses linked container and interact with it using service's name. If you wish to use you own mysql server, please provide the public accessible host
- `DB_PORT` - DB port, default: 3306. 
- `DB_DATABASE` - DB name, default: 80bots. 
- `DB_USERNAME` - DB username, default: user
- `DB_PASSWORD` - DB password, default: user
- `REDIS_HOST` - Redis host, default: redis. The default value uses linked container and interact with it using service's name. If you wish to use you own redis server, please provide the public accessible host
- `REDIS_PORT` - Redis port, default: 6379
- `REDIS_PASSWORD` - Redis password, default: root
- `REDIS_PREFIX` - The app prefix, default: master
- `MAIL_MAILER` - Mailer, default: smtp
- `MAIL_HOST` - Mail service host, default: smtp.gmail.com
- `MAIL_PORT` - Mail service port, default: 587
- `MAIL_FROM_ADDRESS` - Mail from address, default: 80bots@inforca.com
- `MAIL_FROM_NAME` - Mail from name, default: 80bots
- `MAIL_ENCRYPTION` - Mail encryption, default: tls
- `UP_TIME_MINUTES` - Default: 60
- `CREDIT_UP_TIME` - Default: 1
- `REGISTER_CREDITS` - Default: 0
- `AWS_ACCESS_KEY_ID` - AWS access key ID, Default: none
- `AWS_SECRET_ACCESS_KEY` - AWS secret access key, Default: none
- `AWS_DEFAULT_REGION` - AWS default region, Default: us-east-2
- `AWS_BUCKET` - AWS S3 bucket, Default: 80bots
- `AWS_IMAGEID` - Default AWS Image id, Default: ami-02f706d959cedf892
- `AWS_INSTANCE_TYPE` - Default AWS Bot instance type, default: t3.medium
- `AWS_REGION` - AWS Region, Default: us-east-2
- `AWS_URL` - AWS url for the generating the urls, default: https://d265x1r7kc6w9r.cloudfront.net
- `AWS_CLOUDFRONT_INSTANCES_HOST` - AWS url for the instance configuration, default: https://d265x1r7kc6w9r.cloudfront.net
- `STRIPE_KEY` - Stripe key, default: none
- `STRIPE_SECRET` - Stripe secret, default: none
- `SENTRY_LARAVEL_DSN` - Sentry DSN, default: none

The extended description for each of the variables you can find here https://laravel.com/docs

## Installing from scratch:
1. Install Docker on your workstation (https://docs.docker.com/get-docker/)
2. Make sure that your GitHub account has access to abovementioned repositories
3. Add (if you haven’t added yet) your SSH key to your GitHub account (https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)
4. Copy the attached private key to the following directories, naming it id_rsa:
    - `{appRoot}/docker-compose/backend/.ssh`
    - `{appRoot}/docker-compose/web/.ssh`
5. Create and configure `{appRoot}/.env` file according to provided example `{appRoot}/.env.example`
6. Run  `docker-compose up --build` command - initial build may take 15-20 minutes
7. At the end of app builds installation, the following resources should be available in Web Browser:
    - API - By default `localhost:8080/api/ping` or ${DOCKER_API_SERVER_HOST}:${DOCKER_API_SERVER_PORT} from the .env file
    - WEB - By default `localhost` or ${DOCKER_WEB_SERVER_HOST}:${DOCKER_WEB_SERVER_PORT} from the .env file
    - WebSockets - By default `localhost:6001` or ${DOCKER_SOCKET_SERVER_HOST}:${DOCKER_SOCKET_SERVER_PORT} from the .env file
8. It is needed to run Seeders for initial DB configuration by using the following command:
```
docker exec -w /var/www/app 80bots-api php artisan db:refresh
```
Warning! This action will clear the database and populate it with default values!

### Build update and development process:

Most tasks may be implemented without necessity to build containers every time when changes are added, however, some cases require rebuilding. Examples of such cases are:

- Installing additional OS/PHP dependencies
- Updating Supervisor, Cron or code related directly to Queue configurations 
- Changing parameters in .env file
- Changing access to GitHub or SSH key
- All other similar tasks that requires affecting the environment

Rebuild of containers is performed according to official documentation of 
Docker (https://docs.docker.com/)

Almost all rest work related to application development on Laravel as well as on NextJS doesn’t require constant container rebuilds.

### Architecture overview

Configuration of application architecture is provided in docker-compose.yml file and represents a set of services:

1. Proxy server based on Nginx

    Nginx service itself is based on this image https://hub.docker.com/_/nginx, which default starting command was redefined for forming dynamical configurations using .env file
     
    All required config files are located in directory `./docker-compose/proxy/src` and are used for creation of proxy server configuration.
    
    A ready-to-go server config file may be checked in directory `./docker-compose/proxy/conf.d`. 
    Changes in this file may be rewritten when launching the container. For adding corrections, it is necessary to edit files from directory `./docker-compose/proxy/src`.
    
2. MySQL server 

    MySql service itself is based on this image https://hub.docker.com/_/mysql.
    
    The service is configured in such a way that after launching the container, volume is formed between directory with mysql data and   `./docker-compose/mysql/data` directory. 
    
    Thus, it is possible to develop, change a container without losing data from the local environment    
    
3. Redis server

    Redis service itself is based on this image https://hub.docker.com/_/redis/
        
    Service is configured in such a way that after launching the container, volume is formed between directory with Redit data and   `./docker-compose/redis/data` directory. 
    
    Thus, it is possible to develop, change a container without losing data from the local environment    
    
4. Laravel App (API + BG workers) server

    This container build is implemented in `./docker-compose/backend/Dockerfile`.
        
    Installing all OS dependencies, Git SSH keys etc configuration are performed in this file.
      
    When the container is started, Bash Script launches. Every time, when starting, it executes git clone or git pull, depending on the current state, install Composer dependencies and run all the necessary internal services (http server, cron, supervisor)
    
5. NextJS server (React Web App)

    This container build is implemented in `./docker-compose/web/Dockerfile`.
        
    Installing all OS dependencies, Git SSH keys etc configuration are performed in this file.

    When the container is started, Bash Script (`./docker-compose/web/bin/start.sh`) launches. Every time, when starting, it executes git clone or git pull, depending on the current state, install NPM dependencies, start the watcher or build compiled application, depending on `APP_ENV` , and start http server (NextJS)
    
6. Laravel Echo Server (WebSockets)

    Redis service itself is based on this imagehttps://hub.docker.com/r/oanhnn/laravel-echo-server
    
    After starting the application, generated server configurations may be checked in  `./docker-compose/ws/conf.d`.
       
    All services operate inside their own network and interact with each other by links within their own network


#### Additional supporting commands:

Reset the database to its initial configurations: 
```
docker exec -w /var/www/app 80bots-api php artisan db:refresh
```