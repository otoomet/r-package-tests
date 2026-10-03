# r-package-tests

Test scripts and docker images to test R packages on R-devel, reverse
dependencies, and such. 

**Usage**: 

```
$ ./test-in-docker <package-folder> [-a|-n name] [docker buildx options]
```
Where

* <package-folder>   path to the **R package source** folder (mandatory).
* -a, --all          build and test all docker images in parallel
* -n, --name NAME    build and test the **image with the given name**
                      (default: `patched`).  Available names are:
                      * `devel`   : R-devel, on debian testing
                      * `patched` : R-patched, on debian testing
                      * `patched-openblas-fedora` : R-patched, on fedora with openblas.
* useful buildx options are:
   * --no-cache: start building from scratch"

The shared debian setup is defined in `docker/Dockerfile-R`,
parametrized by the `RFLAVOR` build-time argument: `-n devel`
builds it with `RFLAVOR=devel` and `-n patched` with
`RFLAVOR=patched`.  The fedora/openblas setup is different so
it has its own dockerfile, `docker/Dockerfile-patched-openblas-fedora`.

The script `packages.R` reads the package description file and
automatically installs all dependencies based on that.

Note that different R packages may need some adjustment of a
dockerfile if they need certain system packages or gain from unstated
dependencies.

**The output** (results of `R CMD check --as-cran`) is written into folder
`results-foo` when using name `-n foo`.  You can analyze the
test results there.
