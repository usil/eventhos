# Eventhos

## What is eventhos?

Eventhos is an open source platform that applies event-driven architecture principles to allow the user to orchestrate their system integrations using a simple user interface instead of complicated publisher and subscriber source codes in applications. You only need webhooks and rest APIs to integrate all your systems.

Full details in the [wiki](https://github.com/usil/eventhos/wiki)

## How it works?

Basically you have to identify the producers (webhooks) and consumers (apis). Then using th UI you can make a contract between the incoming event produced by a webhook (source system) to the rest api in in the target system. So with this you will have a real time integration between the producer and consumer systems without the complexity of kafka or similars.

![image](https://github.com/usil/eventhos/assets/3322836/2fafd3ab-5ad0-4cd8-a413-78caa15069a2)

Here a sample of contract between producers and consumers

https://github.com/usil/eventhos/assets/3322836/ae8cc37a-b2d5-4a65-ad1f-d853271ed2aa

More uses cases and deep explanation [here](https://github.com/usil/eventhos/wiki/Real-Use-Cases) and [here](https://github.com/usil/eventhos-web/wiki/SendEvent)

## Features

- Register all systems (producers and  consumers)
- Create contracts between your systems
- Oauth2 Security
- Manual retry  on error
- Event Dashboard to see the received events and all the details (request/response)
- Reply-To option
- Json binding to match between the webhook json and target api json
- Vanilla javascript to binding to match between the webhook json and target api json
- Mail on error with the details
- User Management

More details [here](https://github.com/usil/eventhos/wiki/Features)

## Dependencies

Here a minimalist High Level Diagram

![](https://www.planttext.com/api/plantuml/png/LOv13e0W30JlVGNXpXSCFp556Y11CBJgzyM3YhVjP9fTou9DzZL3eqMmX4oA3f9OUSOjAMIb-rrkO3hGm58RXiywoVsj3ZHu57J8f9u0eszQ2b7CD5R1MFiAxxkbullC2m00)

To know more about each dependency check their git repositories.

- [eventhos-api](https://github.com/usil/eventhos-api)
- [eventhos-web](https://github.com/usil/eventhos-web)


## Requeriments

- docker
- docker compose

For windows users, check https://github.com/usil/eventhos/wiki/Windows-Users

## Usage

The aim of this repository is to server as starting point or one click method to start all the eventhos artifacts or dependencies. Chose one of the following options.

> Is recomended to deploy each artifact on its own host instead of all in one host. This is only for local tests or run the integration tests. Check the [deployment section](https://github.com/usil/eventhos/wiki/Deployment) to know hot to deploy it in aws, gcp, azure, etc

### Get last stable version

> default secrets

```sh
bash one_click.sh build=true  latest_branch=true custom_composer_file=docker-compose.yml 
```

Run this anytime you need to get the lastest version

### Get last stable version

> custom secrets

Add the param `config_mode=expert`

```sh
bash one_click.sh build=true  latest_branch=true custom_composer_file=docker-compose.yml config_mode=expert 
```

### Update all except database

```sh
bash one_click.sh build=true  latest_branch=true custom_composer_file=docker-compose.yml skip_database=true
```

### Force clean startup

```sh
bash one_click.sh build=true  latest_branch=true custom_composer_file=docker-compose.yml force_clean_startup=true
```

This will delete the mysql data in ${HOME}/mysql_eventhos folder

Be careful!!!

###  Upgrade only one container

```sh
bash one_click.sh latest_branch=true custom_composer_file=docker-compose.yml service_to_update=eventhos-web operation=update
```

## Integration Test

```sh
bash one_click.sh  custom_composer_file=docker-compose-integration-tests.yml  build=true latest_branch=true
```

## Home Page

If everting worked go to `http://localhost:2110` and you will see this:

![login](https://i.ibb.co/51kZBTy/eventhos-login.jpg)

## Admin credentials

In a command line:

First access to eventhos-api in docker.

```cmd
docker exec -it eventhos-api cat /tmp/credentials.txt
```

Then you will get your credentials

```txt
User:
admin
Password:
SVEvoxC55WclE47hX8ysXFWLh1Qf9oRN
clientid:
CDCsjgE9PbqLnTzZcjmU::usil.app
clientsecret:
QxYOwrpicnKCYyV1lXGhMoUL2JyUbMTr
```

## Database Backup

```
docker exec -it eventhos-db bash /usr/local/bin/manage.sh operation=export_db user=root database_name=eventhos
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