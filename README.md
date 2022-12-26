# Eventhos

This repository implements an easy way to deploy in docker the 3 parts of the eventhos system, _data base, api and web_.

## Git repositories

To know more about each library check their git repository.

- [eventhos-api](https://github.com/usil/eventhos-api)
- [eventhos-web](https://github.com/usil/eventhos-web)

## Requeriments

- docker
- docker-compose

## Usage: Hello World

Download the stable version

```sh
bash one_click.sh build=true  latest_branch=true
```

## Usage: Integration Test

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