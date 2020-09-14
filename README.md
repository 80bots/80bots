![80bots builder](misc/images/80bots.svg)

# 80bots builder

## Brief information:

  This application is developed for simple local deployment of 80bots application architecture that includes the following repositories and they are added as submodules: 

##### Laravel APP (https://github.com/80bots/backend) is intended for:

  - Backend to interact with functional options;
  - Laravel Schedule to perform routine tasks such as sync and data update;
  - Demonized Queue worker based on Supervisor for processing a queue of tasks set;
  - Broadcasting - for notifying subscribers about events (notification via WebSockets);
  - Interaction with Primary database based on MySQL;
  - Bots (instances) management (Start, Stop, Terminate etc.).
  
##### NextJS APP (https://github.com/80bots/frontend) is intended for:

  - Convenient providing data related to bots;
  - Interaction with API for managing data and services;
  - Reviewing info about users and everything related;
  - Configuring custom scripts and parameters of launching bots and instances on which they will be installed.

## Requirements

#### Software:

  - Docker: ^19 - https://docs.docker.com/get-docker/;
  - NodeJS: ^10 - https://nodejs.org/en/download/;
  - NPM: ^6.4 - https://www.npmjs.com/get-npm;
  - Yarn: ^1 - https://classic.yarnpkg.com/en/docs/install;
  - Composer: latest - https://getcomposer.org/doc/00-intro.md;
  - Git: latest - https://git-scm.com/book/en/v2/Getting-Started-Installing-Git.

## Basic (Min required) Environment variables:

#### NGROK APP CONFIG

  - `NGROK_AUTH` - Authentication key for Ngrok account.
  
  To launch via Ngrok, you'll need the API key, because is uses multi-tunnel functionality.

#### LARAVEL APP CONFIG

  - `APP_KEY` - App secret key. Important! If the application key is not set, your user sessions and other encrypted data will not be secure!;

  - `AWS_ACCESS_KEY_ID` - AWS access key ID;
  - `AWS_SECRET_ACCESS_KEY` - AWS secret access key;
  - `AWS_IMAGE_ID` - Default AWS Image id;
  - `AWS_CLOUDFRONT_INSTANCES_HOST` - AWS url for the instance configuration.

  This configuration is a key configuration for starting  80bots. 

## The 80bots Quickstart:

#### Assuming that all abovementioned Requirements are set, it is needed to do the following in order to start the application:
  
  1. Create and configure `{appRoot}/.env` file according to provided example `{appRoot}/.env.example` or start `configure.sh`;
  2. Configure the git config user’s data (name and email) https://help.github.com/en/github/using-git/setting-your-username-in-git;
  3. Run `./start.sh` and wait for the task completion.

  `./start.sh` script installs all required app dependencies, configures docker architecture and runs all required services.

  Browser with required links opens after installation.

  As a result of the successful launch of these tunnels, the local project becomes available for public on the web.
  Such a specific deployment is needed for making bots,deployed on AWS, able to interact with your local environment.

## NOTE:

#### Also, the following resources should be available in Web Browser:

  - Backend - By default `http://localhost:8080/api/ping`;
  - Frontend - By default `http://localhost:80`;
  - WebSockets - By default `http://localhost:6001`.

  Additionally, after Initial setup, it is necessary to perform Laravel & Database configuration that is launched by a command in case if containers are already running:
```
docker exec 80bots-backend php artisan db:refresh
```

  Warning! This action will clear the database and populate it with default values!

## Quick start. 80bots deploy and launching based on AWS.

  It is necessary to have access to Github 80bots repo `https://github.com/80bots` in order to install and launch 80bots.  An account created in aws console is `https://aws.amazon.com/console/`.
  
#### NOTE: 
  You can run service creation manually following 3-6 points(Setup) as well as using was cli, just runing `{appRoot}/deploy-aws.sh`;
  
#### Setup: 

  1. Sign in to AWS Management Console, select EC2<br/><br/>
  ![aws-ec2](misc/images/aws_console_ec2.png)<br/><br/>
  Then, select Key Pair and click `Create Key Pair` button.<br/><br/>
  ![key-pair](misc/images/key_pair.png)<br/><br/>
  Set up a name for your key, click create button<br/><br/> 
  ![create-key-pair](misc/images/create_key_pair.png)<br/><br/>
  and save it for yourself since it is impossible to restore it in case it's lost.
  
  2. Open a terminal on your local workstation, enter `chmod 400 -R {path_to_key}` command (this command is needed for changing access rights to our key)<br/><br/>
  ![changing-access](misc/images/changing_access.png)<br/><br/>
  We'll need it for access to our instance. 
  
  3. Open CloudFormation in was console (screenshot_5), click "create stack"<br/><br/>
  ![aws-console-cloudformation](misc/images/aws_console_cloudformation.png)<br/><br/>
  click `create stack`<br/><br/>
  ![create-stack](misc/images/create_stack.png)<br/><br/>
  upload {appRoot}/template.yml template for automatic running all required services (you can find the template in 80bots repo). Click `next`<br/><br/>
  ![upload-template](misc/images/upload_template.png)<br/><br/>
  
  4. Then you need to set up a name for your stack and enter KeyName of the created key. Click `next`<br/><br/>
  ![stack-details](misc/images/stack_details.png)<br/><br/>
  
  5. You can set up required configurations (optional), then click `next`<br/><br/>
  ![configure-stack](misc/images/configure_stack.png)<br/><br/>
  
  6. Review set settings and click `create stack`<br/><br/>
  ![review](misc/images/review.png)<br/><br/>

  7. On this stage, service creation statuses are displayed<br/><br/>
  ![status](misc/images/status.png)<br/><br/>
  
  #### Important!
  Due to the fact that currently, the source repository is private and the Github account that interacts with this repository should have two-factor authentication enabled, you should follow the next instruction: 
  
  Open a terminal, get to the config file by entering nano `~/.ssh/config` command and enter the following settings: 
  ```
  Host your_custom_name
      ForwardAgent yes
      User ec2-user
      Hostname instance_Public_IP
      IdentityFile absolute_path_to_your_key
  ```
  ![config](misc/images/config.png)<br/><br/>
  ![ip](misc/images/ip.png)<br/><br/>
  Save changes and now you can get to the instance via SSH by using `ssh your_custom_name` command anytime.
  
#### Deployment: 

  1. Connect to the instance using `ssh your_custom_name` command<br/><br/>
  ![connect](misc/images/connect.png)<br/><br/> 
  
  2. After you connected to your instance successfully, enter `./deploy.sh` command and configure an environment by entering relevant info in order to launch 80bots correctly. The installation will request entering such info as AWS credentials, store configuration, and basic app settings. Details of requested info:
  
  - `SERVICE` - for launching an application basing on was instance
  - `PUBLIC_URL` - public address of the instance run by you<br/><br/>
  ![public-url](misc/images/public_url.png)<br/><br/>
  - `APP_KEY` - App secret key. Important! If the application key is not set, your user sessions and other encrypted data will not be secure!;
  - `AWS_ACCESS_KEY_ID` - AWS access key ID;
  - `AWS_SECRET_ACCESS_KEY` - AWS secret access key;<br/><br/>
   ![aws-access-key-id](misc/images/aws_access_key_id.png)<br/><br/>
   ![create-key](misc/images/create_key.png)<br/><br/>
   ![download-key](misc/images/download_key.png)<br/><br/>
  - `AWS_IMAGE_ID` - Default AWS Image id;
  
  - `AWS_CLOUDFRONT_INSTANCES_HOST` - AWS url for the instance configuration.<br/><br/>
   ![cloudFront](misc/images/cloudFront.png)<br/><br/>
   ![cloudFront_url](misc/images/cloudFront_url.png)<br/><br/>
  
  
  3. After completion of all installs, 80bots will be available by instance public DNS address,  with which all above-mentioned operations were performed.
  
#### Note:  
  Available resources: 
  - `http://your_public_DNS.compute.amazonaws.com:80` - frontend
  - `http://your_public_DNS.compute.amazonaws.com:8080` - backend
  - `http://your_public_DNS.compute.amazonaws.com:80` - websocet

## Build update and development process:

  Most tasks may be implemented without necessity to build containers every time when changes are added, however, some cases require rebuilding.

#### Examples of such cases are:

  - Installing additional OS/PHP dependencies;
  - Updating Supervisor, Cron or code related directly to Queue configurations;
  - Changing parameters in .env file;
  - All other similar tasks that requires affecting the environment.

  Rebuild of containers is performed according to official documentation of
  Docker (https://docs.docker.com/)

  Almost all rest work related to application development on Laravel as well as on NextJS doesn’t require constant container rebuilds.

## Environment variables:

  When you launch 80Bots, you can configure environment, specifying the various parameters in .env file. To do this, you need to create and configure `{appRoot}/.env` file according to the provided example `{appRoot}/.еnv.variables`.
  Please note that none of the variables given below will not have any effect until a container is restructured.

#### SERVICE APP CONFIG

  - `TUNNEL_SERVICE` - The name of the service you want to use to start the tunnel: `ngrok` or `serveo`, default:`ngrok`.

  Optionally, you can deploy the application using serveo tunnel.
  If you're using Serveo, please make sure that the server is available and functioning, since there are situations when access to it is limited.

  After successfully running the local version of the application in the .env file in a specific service (Serveo or Ngrok), a dynamic link to the tunnels is created, and these tunnels start.
#### PROXY SERVER CONFIG

  - `DOCKER_FRONTEND_SERVER_HOST` - FRONTEND host, default: localhost (Custom usage example: 80bots.loc);
  - `DOCKER_FRONTEND_SERVER_PORT` - FRONTEND port, default: 80 (Custom usage example: 80);
  - `DOCKER_BACKEND_SERVER_HOST` - BACKEND host, default: localhost (Custom usage example: api.80bots.loc);
  - `DOCKER_BACKEND_SERVER_PORT` - BACKEND port, default: 8080 (Custom usage example: 80);
  - `DOCKER_SOCKET_SERVER_HOST` - WS host, default: localhost (Custom usage example: ws.80bots.loc);
  - `DOCKER_SOCKET_SERVER_PORT` - WS post, default: 6001 (Custom usage example: 80).

  If you consider to use your own custom hosts and ports please make sure you've added them to `/etc/hosts`.

  If you decide to use configuration, verify that all specified ports are not used, otherwise you may easily redefine them in the abovementioned parameters. 

#### MYSQL SERVER CONFIG:

  - `DOCKER_MYSQL_ROOT_PASSWORD` - Password to create on the service startup phase for the `root` user, default: root;
  - `DOCKER_MYSQL_USER` - Additional non root user which will be created on the service startup phase, default: user;
  - `DOCKER_MYSQL_PASSWORD` - Additional user's password, default: user;
  - `DOCKER_MYSQL_DATABASE` - Default database name which will be created if not exists on startup phase, default: user.

  This configuration is a key configuration for starting MySQL container and change of these parameters won’t have any influence until the container rebuild. 

##### LARAVEL APP CONFIG:

  - `APP_NAME` - Name of the Laravel App, default: 80bots;
  - `APP_ENV` - Environment, default: local;
  - `APP_DEBUG` - Debug enabled, default: false (see more on https://laravel.com/docs);
  - `APP_URL` - The public accessible App server url (this variable is generated automatically when launching the application), default: http://localhost:8080 (Based on PROXY SERVER CONFIG section);
  - `WEB_CLIENT_URL` - The public accessible Web app server url (this variable is generated automatically when launching the application), default: http://localhost:80 (Based on PROXY SERVER CONFIG section);
  - `WS_URL` - The public accessible WebSockets url (this variable is generated automatically when launching the application), default: http://localhost:6001 (Based on PROXY SERVER CONFIG section);
  - `LOG_CHANNEL` - The log channel, default: stack;
  - `BROADCAST_DRIVER` - Broadcast driver, default: redis. Warning! Changing of this parameter could affect the app stability and functionality;
  - `QUEUE_CONNECTION` - Broadcast driver, default: redis. Warning! Changing of this parameter could affect the app stability and functionality;
  - `CACHE_DRIVER` - Cache driver, default: file;
  - `SESSION_DRIVER` - Session driver, default: file;
  - `SESSION_LIFETIME` - Session lifetime, default 120;
  - `DB_CONNECTION` - DB driver (connection), default: mysql. Warning! Changing of this parameter could affect the app stability and functionality;
  - `DB_HOST` - DB host, default: mysql. The default value uses linked container and interact with it using service's name. If you wish to use you own mysql server, please provide the public accessible host;
  - `DB_PORT` - DB port, default: 3306;
  - `DB_DATABASE` - DB name, default: 80bots;
  - `DB_USERNAME` - DB username, default: user;
  - `DB_PASSWORD` - DB password, default: user;
  - `REDIS_HOST` - Redis host, default: redis. The default value uses linked container and interact with it using service's name. If you wish to use you own redis server, please provide the public accessible host;
  - `REDIS_PORT` - Redis port, default: 6379;
  - `REDIS_PASSWORD` - Redis password, default: root;
  - `SENTRY_LARAVEL_DSN` - Sentry DSN, default: none;
  - `AWS_BUCKET` - AWS S3 bucket, default:80bots;
  - `AWS_INSTANCE_TYPE` - Default AWS Bot instance type, default: t3.medium;
  - `AWS_REGION` - AWS Region, default: us-east-2.  

  The extended description for each of the variables you can find here https://laravel.com/docs.

##### AUTOGENERATED:

  - `API_URL` - Publicly available auto generating URL-address of the application server, default value : http://localhost:8080;
  - `WS_URL`- Publicly available auto generating URL-address of ws application, default value: http://localhost:6001;
  - `FRONTEND_SUBDOMAIN` - Frontend subdomain for setting up ngrok tunnel;
  - `BACKEND_SUBDOMAIN`- Backend subdomain for setting up ngrok tunnel;
  - `WS_SUBDOMAIN`- Ws subdomain for setting up ngrok tunnel.
  
##### HELPERS:

  When writing custom scripts, you can use an internal function - `notify()`, that output required statuses, script work progress to Workforce page. It is not needed to import this function. 
  
  `notify()` - receives one parameter (status). This parameter should have a string type, otherwise the function throws an error. 
  

## Architecture overview

  Configuration of application architecture is provided in docker-compose.yml file and represents a set of services:

#### Proxy server based on Nginx

  Nginx service itself is based on this image https://hub.docker.com/_/nginx, which default starting command was redefined for forming dynamical configurations using .env file
   
  All required config files are located in directory `./docker-compose/proxy/src` and are used for creation of proxy server configuration.
  
  A ready-to-go server config file may be checked in `./docker-compose/proxy/conf.d` directory. NOTE: Changes in this directory will affect nothing! For adding corrections, it is necessary to edit files from `./docker-compose/proxy/src` directory.

  
#### MySQL server

  MySql service itself is based on this image https://hub.docker.com/_/mysql.
  
  The service is configured in such a way that after launching the container, volume is formed between directory with mysql data and   `./docker-compose/mysql/data` directory.
  
  Thus, it is possible to develop, change a container without losing data from the local environment
  
#### Redis server

  Redis service itself is based on this image https://hub.docker.com/_/redis/
      
  Service is configured in such a way that after launching the container, volume is formed between directory with Redit data and   `./docker-compose/redis/data` directory.
  
  Thus, it is possible to develop, change a container without losing data from the local environment   
  
#### Laravel App (API + BG workers) server

  This container build is implemented in `./docker-compose/backend/Dockerfile`.
          
  When the container is started, Bash Script launches. Every time, when starting, it executes a few auxiliary things, re-generate the .env file and run all the necessary internal services (cron, supervisor and php-fpm server)
  
#### NextJS server (React Web App)

  This container build is implemented in `./docker-compose/frontend/Dockerfile`.

  When the container is started, Bash Script (`./docker-compose/frontend/bin/start.sh`) launches. Every time, when starting, re-generate the .env file, start the watcher or build compiled application, depending on `APP_ENV` , and start http server (NextJS)
  
#### Laravel Echo Server (WebSockets)

  Redis service itself is based on this image https://hub.docker.com/r/oanhnn/laravel-echo-server
  
  After starting the application, generated server configurations may be checked in  `./docker-compose/ws/conf.d`.
     
  All services operate inside their own network and interact with each other by links within their own network

#### Ngrok

   Ngrok service is based on the image: https://hub.docker.com/r/wernight/ngrok/

   When launching the application, a new image is formed, based on Ngrok image.
   The server is set in the way that after launching a container, the `ngrok.yml` root file is replaced with the one containing necessary configurations to provide the ability of running multiple simultaneous tunnels.

## Shell Scripts:
   - `install.sh` - This script clones frontend and backend from a git repository and installs a required software.
   - `start.sh` - this script runs an application for selected service and generates required variables for .env file. 
   - `configure.sh` - this script runs install.sh, creates .env file and generates required variables, and then runs start.sh(!!!Removes an existing .env file, if it exists)
   - `deploy-aws.sh` - this script runs cloudformation `80bots-template.yaml` template that installs required resources to aws. It is necessary for correct work of 80bots basing on aws instance.
## Additional supporting commands:

#### Refresh Database:
```
docker exec 80bots-backend php artisan db:refresh
```

#### Refresh Cache:
```
docker exec 80bots-backend php artisan cache:refresh
```

#### Rebuild all containers:

```
docker-compose up --build
```

#### Rebuild specific container:
```
docker-compose up --build {container_name}
```

#### Stop all containers:

```
Docker-compose stop
```

#### Remove ALL the containers and images (Warning! This command will remove all of your images and containers!):
```
docker system prune -a
```



