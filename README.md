# Eventhos Docker 0.0.2

This repository implements an easy way to deploy in docker the 3 parts of the eventhos system, _data base, api and web_.

It uses git sub modules to copy the source code for the api and the web.

## The Api and the Web

To know more about each library check their git repository.

- [eventhos-api](https://github.com/usil/eventhos-api)
- [eventhos-web](https://github.com/usil/eventhos-web)

## Usage

First clone the repository `git clone https://github.com/usil/eventhos.git`. Then run `git submodule update --init`.

After that run `docker-compose up -d --build`. This will deploy 3 apps in docker, first a mysql data base with the eventhos model, then the [eventhos-api](https://github.com/usil/eventhos-api) and finally [eventhos-web](https://github.com/usil/eventhos-web).

If everting worked go to `http://localhost:2110` and you will see this:

![login](https://i.ibb.co/51kZBTy/eventhos-login.jpg)

### Getting the admin username and password

In a command line:

First access to eventhos-api in docker.

```cmd
  docker exec -it eventhos-web bash
```

To read the credentials files

```cmd
  cat credentials.txt
```

Then you will get your credentials

```txt
Credentials for the admin user in it.

          Username: admin

          Password: secret
          Credentials for the admin client.

          client_id: clientId

          client_secret: secret
```

### Default ports

The api will run by default in the port `2109`. you can change this behavior by modifying the environment variable `PORT` in the docker compose file. If you decided to change the port also modify the environment variable `URL` in `eventhos-web` part of the docker compose file to reflect the new port.

The web will run in the port `2110`, to change it you will need to modify the package.json inside eventhos-web, in the following line.

```json
{
  "start": "nodeboot-spa-server dist/template-dashboard -s settings.json -p 2110 --allow-routes"
}
```

### Using it with ActiveMQ

This repository has everting ready to use activemq or any queue manager. For this you will need to run the `docker-compose-queue.yml` file with `docker-compose -f docker-compose-queue.yml up --build -d eventhos-api`.

This docker-compose file will add the following:

```yml
eventhos-activemq:
  image: webcenter/activemq:latest
  container_name: activemq
  ports:
    - 8161:8161
    - 61616:61616
    - 61613:61613
  environment:
    # ACTIVEMQ_CONFIG_NAME: eventhos
    ACTIVEMQ_CONFIG_MINMEMORY: 512
    ACTIVEMQ_CONFIG_MAXMEMORY: 1024
    ACTIVEMQ_CONFIG_DEFAULTACCOUNT: false
    ACTIVEMQ_ADMIN_LOGIN: admin
    ACTIVEMQ_ADMIN_PASSWORD: admin
    ACTIVEMQ_USERS_eventhos: secret
    ACTIVEMQ_GROUPS_owners: eventhos
    JAVA_OPTS: -Dfile.encoding=UTF-8
    TZ: America/Lima
  restart: always
```

Modify those variables as you like but keep it mind to also change the variables in the `eventhos-api` service:

```yml
environment:
  USE_QUEUE: true
  QUEUE_HOST: host.docker.internal
  QUEUE_PORT: 61613
  QUEUE_USER: eventhos
  QUEUE_PASSWORD: secret
  QUEUE_DESTINATION: eventhos
```

## Contributors

<table>
  <tbody>
    <td>
      <img src="https://i.ibb.co/88Tp6n5/Recurso-7.png" width="100px;"/>
      <br />
      <label><a href="https://github.com/TacEtarip">Luis Huertas</a></label>
      <br />
    </td>
    <td>
      <img src="https://avatars0.githubusercontent.com/u/3322836?s=460&v=4" width="100px;"/>
      <br />
      <label><a href="http://jrichardsz.github.io/">JRichardsz</a></label>
      <br />
    </td>
  </tbody>
</table>
