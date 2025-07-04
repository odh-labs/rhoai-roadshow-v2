# rhoai-roadshow

### 🏃‍♀️ Running the docs site
If you have Node installed, you can start the site with the following command from within the `docs` directory:  
```
npm i docsify-cli -g
docsify serve ./docs
```

## Running the site from a container
If you want to run Node from within a container, you can use the following command from the top directory of the cloned git repository.

Note: This image is derived from the Red Hat Node.js Image Builder image.

```
podman run -it --rm --name=nodejs-dev -p 3000:3000 -v $PWD:/workdir:Z quay.io/bryonbaker/nodejs-22:basic
```

Once you have done that you can change into the `docs` directory and launch the site as described above.