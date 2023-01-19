# This folder contains all the elements used for a dev container

They are used to facilitate building ROMs.

The available pre build images are:

* ghcr.io/n64-tools/dev-container: contains all elements to build a ROM image.

To choose the dev container you want to use, adjust `devcontainer.json` and change the `"dockerFile": "Dockerfile"` elements for the image you'd liked to use:

* `Dockerfile` to use the pre build container with all the elements to build a ROM