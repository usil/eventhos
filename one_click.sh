workspaces_path=$(pwd)

function delete_image_if_exist {
  image=$(docker images "$1" -a -q)
  if [ ! "$image" == "" ]; then
    echo "deleting image: $image"
    docker rmi -f "$image"
  fi
}

for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)
   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"
   export "$KEY"="$VALUE"
done

echo "#################"
echo "Updating source code"
echo "#################"

cd $workspaces_path/eventhos-api
git fetch
latest_branch=$(git for-each-ref --sort=-committerdate | head -n 1 | awk -F '/' '{ print $NF }')
git checkout $latest_branch
git pull origin $latest_branch

cd $workspaces_path/eventhos-web
git fetch
latest_branch=$(git for-each-ref --sort=-committerdate | head -n 1 | awk -F '/' '{ print $NF }')
git checkout $latest_branch
git pull origin $latest_branch


echo "#################"
echo "Launching"
echo "#################"
cd $workspaces_path

export JWT_SECRET=$(uuidgen)
export CRYPTO_KEY=$(uuidgen)
export MYSQL_PASSWORD=$(uuidgen)
export MYSQL_PASSWORD=$(uuidgen)

if [ ! -f .env ]; then
  echo "" > .env
else
  echo ".env file already exist"
  cat .env
  export $(cat .env | xargs)
fi

if [[ -z "$EVENTHOS_API_BASE_URL" ]]
then
  echo "Enter EVENTHOS_API_BASE_URL: http://localhost:2109, http://10.20.30.40:2109 or https://eventhos.foo.com"
  read _EVENTHOS_API_BASE_URL
  export EVENTHOS_API_BASE_URL=$_EVENTHOS_API_BASE_URL
  echo "EVENTHOS_API_BASE_URL=$EVENTHOS_API_BASE_URL" >> .env
fi

if [[ -z "$EVENTHOS_WEB_PORT" ]]
then
  echo "Enter EVENTHOS_WEB_BASE_URL: (2110) "
  read _EVENTHOS_WEB_PORT
  export EVENTHOS_WEB_PORT=$_EVENTHOS_WEB_PORT
  echo "EVENTHOS_WEB_PORT=$EVENTHOS_WEB_PORT" >> .env
fi

if [[ -z "$EVENTHOS_API_PORT" ]]
then
  echo "Enter EVENTHOS_API_PORT: (2109) "
  read _EVENTHOS_API_PORT
  export EVENTHOS_API_PORT=$_EVENTHOS_API_PORT
  echo "EVENTHOS_API_PORT=$EVENTHOS_API_PORT" >> .env
fi

# https://stackoverflow.com/a/50850881

if [ "$build" == "true" ]; then
  docker-compose down
  delete_image_if_exist "eventhos_eventhos-web"
  delete_image_if_exist "eventhos_eventhos-api"
  docker-compose up -d --build
else
  docker-compose down && docker-compose up -d
fi
