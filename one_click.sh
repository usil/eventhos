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

function read_required_env_variables {
  for line in $(cat $1 | tr ' ' '\n' | sort -u | grep -Po '\${.+}' )
  do
      var="${line/\$/""}"
      var="${var/\{/""}"
      var="${var/\}/""}"
      var=$(echo "$var" | cut -d ":" -f 1 | xargs)
      if [[ -z "${!var}" ]]; then
          echo "Enter $var value:"  && read _value
          export $var=$_value
          echo "$var=$_value" >>.env
      fi
  done  
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

    rm -rf "$workspace_location/$repository_name"

    cd "$workspace_location"
    if [ "$latest_branch" == "true" ]; then
      echo "git clone $git_repository_url"
      git clone $git_repository_url
      cd "$workspace_location/$repository_name"
      git fetch
      branch=$(git for-each-ref --sort=-committerdate | head -n 1 | awk -F '/' '{ print $NF }')
      echo -e "\n>>>>>>>>>>> Latest branch: $branch\n"
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
cd "$workspace_location"

composer_file=
if [ ! -z "$custom_composer_file" ]; then
  composer_file=$custom_composer_file
else
  composer_file=docker-compose.yml
fi

echo "docker compose file: $composer_file"

if [ "$force_clean_startup" == "true" ]; then
  read -p "Are you sure you want a clean startup? This will delete all your mysql data(${HOME}/mysql_eventhos) and the .env file (yes|no): " answer
  if [ "$answer" == "yes" ]; then
    sudo rm -rf ${HOME}/mysql_eventhos
    rm -f $workspace_location/.env
  fi
fi

if [ "$operation" == "update" ]; then
  echo "#################"
  echo "Updatig: $service_to_update"
  echo "#################"
  if [ ! -f $workspace_location/.env ]; then
    if [ -s $workspace_location/.env ]; then
      export $(cat .env | xargs)
    fi
  fi  
  docker compose up -d --build $service_to_update
  exit 0  
fi

# we are in the create mode

if [ -z "${config_mode}" ]; then
  export config_mode=default
fi

case "$config_mode" in

  default)
    echo  "config mode: default"
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

    read_required_env_variables "$composer_file"          
    ;;

  *)
esac

echo "Delete containers and images"

if [ "$skip_database" == "true" ]; then
  docker compose rm -s -v eventhos-web
  docker compose rm -s -v eventhos-api
else
  docker compose -f $composer_file down    
fi

# https://stackoverflow.com/a/50850881
if [ "$build" == "true" ]; then
  delete_image_if_exist "eventhos_eventhos-web"
  delete_image_if_exist "eventhos_eventhos-api"

  if [ "$skip_database" == "true" ]; then
    docker compose -f $composer_file up -d --build --force-recreate --no-deps eventhos-web eventhos-api
  else
    docker compose -f $composer_file up -d --build --force-recreate --no-deps
  fi
else
  if [ "$skip_database" == "true" ]; then
    docker compose  -f $composer_file up -d eventhos-web eventhos-api
  else
    docker compose  -f $composer_file up -d
  fi
  
fi
