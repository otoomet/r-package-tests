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
* -n, --name NAME    build and test the **image with the given name**.
                     e.g. to test package on `Dockerfile-foo` you need
                     to use `-n foo`.
* useful buildx options are:
   * --no-cache: start building from scratch"

Each dockerfile should build the corresponding image, currently
included are R-devel (on debian testing), R-patched (debian testing)
and R-pathced (fedora/openblas).

The dockerfile should build the OS image with all necessary system
packages installed, thereafter download the desired type
of R, and configure and build it with desired options.

The script `packages.R` reads the package description file and
automatically installs all dependencies based on that.

Note that different R packages may need some adjustment of the
dockerfile if they need certain system packages or gain from unstated
dependencies.

**The output** (results of `R CMD check --as-cran`) is written into folder
`results-foo` when using name `-n foo`.  You can take a look at the
test results there.
