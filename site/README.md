# rhoai-roadshow

### 🏃‍♀️ Running the docs site
If you have Node installed, you can start the site with the following command:  
```
npm i docsify-cli -g
docsify serve ./docs
```

## Running the site from a container
If you want to run Node from within a container, you can use the following command from within the site directory and then start the site from within the container image. 

Note: This image is derived from the Red Hat Node.js Image Builder image.

```
#! /bin/bash

podman run -it --rm --name=nodejs-dev -p 3000:3000 -v $PWD:/workdir:Z quay.io/bryonbaker/nodejs-22:basic
```

