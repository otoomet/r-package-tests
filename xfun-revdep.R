#!/usr/bin/env Rscript
## This script tests R package reverse dependencies using
## xfun::rev_check.
##
## Usage:
## xfun-revdep <package folder> [-u|--update]
##     package folder: the folder that contains the R package source
##         including DESCRIPTION
##     -u/--update: update all packages
##

# Function to show help
show_help <- function() {
  cat("Usage: xfun-revdep <package folder> [-u|--update]\n")
  cat("\n")
  cat("Arguments:\n")
  cat("  <package folder>  path to the R package source folder\n")
  cat("                    (must contain a DESCRIPTION file)\n")
  cat("\n")
  cat("Options:\n")
  cat("  -h, --help        Show this help message\n")
  cat("  -u, --update      Update all packages before the check\n")
  cat("\n")

  # Exit after showing help
  q(save = "no")
}

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check for help flag
if (any(c("-h", "--help") %in% args)) {
  show_help()
}

# Detect the -u/--update flag
update <- any(c("-u", "--update") %in% args)

# The package folder is the first argument that is not a known flag
known_flags <- c("-h", "--help", "-u", "--update")
positional <- setdiff(args, known_flags)
package_folder <- if (length(positional) > 0) positional[1] else NA

# If no package folder provided, show help
if (is.na(package_folder)) {
  cat("Error: Package folder not specified\n")
  show_help()
}

# Normalize (also expands '~') and verify it is an existing directory
package_folder <- normalizePath(package_folder, mustWork = TRUE)

# Verify the DESCRIPTION file exists
desc_file <- file.path(package_folder, "DESCRIPTION")
if (!file.exists(desc_file)) {
  cat(sprintf("Error: no DESCRIPTION in '%s'; is it an R package folder?\n", package_folder))
  show_help()
}

# Read the package name from DESCRIPTION
desc <- read.dcf(desc_file)
pkg <- desc[1, "Package"]

## rev_check() downloads sources and creates '*.Rcheck' dirs in the
## current working directory, so run it from a dedicated subfolder.
## (package_folder is already absolute, so it stays valid after setwd.)
results_dir <- "revdep"
dir.create(results_dir, showWarnings = FALSE)
setwd(results_dir)

cat(sprintf("Checking %s\n", pkg))
options(mc.cores = parallel::detectCores() %/% 2,
        xfun.rev_check.download_cores = parallel::detectCores() %/% 2)
                           # There may be compilation errors with too high
                           # parallelism
xfun::rev_check(pkg, update = update, src = package_folder)
