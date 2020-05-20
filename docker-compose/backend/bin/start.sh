#!/bin/bash
startServer()
{
  echo "Starting the API server" && ./update.sh && ./server.sh
}

startWorker()
{
  echo "Starting the Laravel Queue worker" && ./update.sh && ./queue-worker.sh
}

case "$1"
  in
    api)
      startServer
      ;;

    worker)
      startWorker
      ;;
    *)
      echo "Sorry, the service is not specified or unsupported. Pass a valid arg for the running. Allowed values is: 'api' or 'worker'"
      echo "Example: ./start.sh api"
      exit 1
esac