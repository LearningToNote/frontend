# frontend

This repository contains the frontend component of the project.

## Requirements

1. Nodejs (tested with >= 1.0), npm must be in your PATH.
2. Run `npm install -g bower grunt`.
3. Install the project dependencies with `npm install` and `bower install`.
4. Be sure to initialize/update the submodules correctly, then install their requirements as well.

## Deployment

Use grunt to deploy the application:

`grunt deploy`

This will build the editor and server component as well as the production version of the application and start a web server on the local machine.
The deployed application can then be reached via `https://localhost:8080/dist/index.html`.

## Development

`grunt serve` will start a development server on `https://localhost:9000/`, and will take the necessary steps to be as responsive as possible to changed source code. Namely, grunt will watch source files, images, templates, and so on for changes and react with the corresponding build tasks. With LiveReload.js, the browser will reload the page if necessary. See [Gruntfile.js](Gruntfile.js) for details.

For development purposes you might want to use [yeoman](http://yeoman.io/) (`npm install -g yo generator-angular`). Yo can generate additional routes, controllers, and so on. Be sure to use the flag `--coffee`.

## Tests

You can run unit tests with `grunt test`. These will also execute before deployment.
