# r-package-tests

Test scripts and dockerfiles to test R packages on R-devel and other R
versions, and reverse dependencies.  The repository contains two
independent scripts:

* `test-in-docker`: check the package itself in docker containers
  with different R versions/OSes.
* `xfun-revdep`: check the reverse dependencies of the package
  using `xfun::rev_check`.

## test-in-docker

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
it has its own dockerfile,
`docker/Dockerfile-patched-openblas-fedora`.  It is easy to add your
own R/OS version by creating a corresponding dockerfile.

Note that different R packages may need some adjustment of a
dockerfile if they need certain system packages or gain from unstated
dependencies.

The script `packages.R` reads the package description file and
automatically installs all dependencies based on that.  It is not
intended to be executed by the user.

**The output** (results of `R CMD check --as-cran`) is written into folder
`results-foo` when using name `-n foo`.  You can analyze the
test results there.

**Requirements**: docker, including buildx tools is installed and
available. 


## xfun-revdep

Tests the **reverse dependencies** of a package: it uses
`xfun::rev_check()` to install the package from its source folder,
find all of its reverse dependencies on CRAN, and run `R CMD check`
on each of them in parallel.
See [xfun::rev_check()
documentation](https://cran.r-project.org/web/packages/xfun/refman/xfun.html#rev_check)
for more information.

**Usage**:

```
$ ./xfun-revdep.R <package folder> [-u|--update]
```

Where

* <package folder>  path to the **R package source** folder
                     (must contain a `DESCRIPTION` file); the package
                     name is read from its `Package:` field.
* -u, --update      update all packages before the check.

Note that `xfun::rev_check()` works in the **current working
directory** (it downloads the source packages of the reverse
dependencies there, and creates `*.Rcheck` directories for failed
checks), so it is recommended to run the script from a dedicated
folder.  Failed checks are indicated by leftover `*.Rcheck`
directories; re-running the script rechecks only those.
