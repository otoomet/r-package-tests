This project contains a script (test-in-docker) to test an R package
using R-devel and other versions of R in docker containers.
The corresponding dockerfiles are
"docker/Dockerfile-devel", "docker/Dockerfile-patched" and potentially more.

The script should:

* get the package folder name as its first argument (currently
  hardcoded as "pkg" in the dockerfile.  This should be a mandatory
  argument and cause an error if not supplied.
* build the docker image that contains the relevant version of R and
  adds the necessary system packages (done
  in the dockerfile).
* copies the R package into the image.  Note: the image will be
  outside of the context, so probably need to use
  `--build-context=...` of the `docker buildx`.
* copies the `docker/build-check` script into the image.
* there should be an option to build and test multiple images in
  parallel (currently the `-a` option).
