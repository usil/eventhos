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

### Default ports

The api will run by default in the port `2109`. you can change this behavior by modifying the environment variable `PORT` in the docker compose file. If you decided to change the port also modify the environment variable `URL` in `eventhos-web` part of the docker compose file to reflect the new port.

The web will run in the port `2110`, to change it you will need to modify the package.json inside eventhos-web.

```json
{
    /// change 2110 to the desired port
    ...
  "start": "nodeboot-spa-server dist/template-dashboard -s settings.json -p 2110 --allow-routes"
    ...
}
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
