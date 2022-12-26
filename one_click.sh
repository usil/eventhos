workspace_location=$(pwd)

# get input arguments
for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)
   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"
   export "$KEY"="$VALUE"
done

function delete_image_if_exist {
  image=$(docker images "$1" -a -q)
  if [ ! "$image" == "" ]; then
    echo "deleting image: $image"
    docker rmi -f "$image"
  fi
}



echo "#################"
echo "Updating source code"
echo "skip_update_code: $skip_update_code"
echo "#################"

if [ -z "$skip_update_code" ] && [ ! "$skip_update_code" == "true" ]; then

  while IFS="" read -r git_repository_url || [ -n "$git_repository_url" ]
  do    

    echo "cloning $git_repository_url"
    repository_name=$(echo "$git_repository_url"  | rev |  cut -d / -f 1 | rev | cut -d . -f 1)
    
    if [ -z "$repository_name" ]; then
      echo "cannot obtain repository name from $git_repository_url"
      echo "check if repositories.txt has valid git clone urls and try again"
      exit 666
    fi

    echo "repository_name: $repository_name"

    rm -rf $workspace_location/$repository_name

    cd $workspace_location
    if [ "$latest_branch" == "true" ]; then
      echo "git clone $git_repository_url"
      git clone $git_repository_url
      cd $workspace_location/$repository_name
      git fetch
      branch=$(git for-each-ref --sort=-committerdate | head -n 1 | awk -F '/' '{ print $NF }')
      git checkout $branch
      git pull origin $branch
    else
      echo "git clone $git_repository_url -b main"
      git clone $git_repository_url -b main
    fi  

  done < repositories.txt  

fi


echo "#################"
echo "Launching"
echo "#################"
cd $workspace_location

if [ -z "${config_mode}" ]; then
  export config_mode=default
fi

case "$config_mode" in

  default)
    echo  "config mode: default"
    export JWT_SECRET=$(uuidgen)
    export CRYPTO_KEY=$(uuidgen)
    export MYSQL_PASSWORD=$(uuidgen)
    local_ip="$(hostname -I | awk '{print $1}')"
    export EVENTHOS_API_BASE_URL=http://$local_ip:2109
    ;;

  expert)
    echo  "config mode: expert"
    if [ ! -f .env ]; then
      echo "" > .env
    else
      if [ -s .env ]; then
        export $(cat .env | xargs)
      else
        echo ".env is empty"
      fi
    fi

    if [[ -z "$EVENTHOS_API_BASE_URL" ]]
    then
      echo "Enter EVENTHOS_API_BASE_URL: "
      read _EVENTHOS_API_BASE_URL
      export EVENTHOS_API_BASE_URL=$_EVENTHOS_API_BASE_URL
      echo "EVENTHOS_API_BASE_URL=$EVENTHOS_API_BASE_URL" >> .env
    fi

    if [[ -z "$EVENTHOS_API_PORT" ]]
    then
      echo "Enter EVENTHOS_API_PORT: (2109) "
      read _EVENTHOS_API_PORT
      export EVENTHOS_API_PORT=$_EVENTHOS_API_PORT
      echo "EVENTHOS_API_PORT=$EVENTHOS_API_PORT" >> .env
    fi

    if [[ -z "$EVENTHOS_WEB_PORT" ]]
    then
      echo "Enter EVENTHOS_WEB_PORT: (2110) "
      read _EVENTHOS_WEB_PORT
      export EVENTHOS_WEB_PORT=$_EVENTHOS_WEB_PORT
      echo "EVENTHOS_WEB_PORT=$EVENTHOS_WEB_PORT" >> .env
    fi    
    ;;

  *)
esac

composer_file=
if [ ! -z "$custom_composer_file" ]; then
  composer_file=$custom_composer_file
else
  composer_file=docker-compose.yml
fi

echo "docker-compose file: $composer_file"

# https://stackoverflow.com/a/50850881
if [ "$build" == "true" ]; then
  docker-compose -f $composer_file down
  delete_image_if_exist "eventhos_eventhos-web"
  delete_image_if_exist "eventhos_eventhos-api"
  docker-compose -f $composer_file up -d --build --force-recreate --no-deps
else
  docker-compose  -f $composer_file down && docker-compose  -f $composer_file up
fi
