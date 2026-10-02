#!/usr/bin/env Rscript

# Function to show help
show_help <- function() {
  cat("Usage: packages.R [OPTIONS] [PACKAGE_FOLDER]\n")
  cat("\n")
  cat("Options:\n")
  cat("  -h, --help       Show this help message\n")
  cat("  -d, --dir PATH   Path to the package folder\n")
  cat("\n")
  cat("Arguments:\n")
  cat("  PACKAGE_FOLDER   Path to the package folder\n")
  
  # Exit after showing help
  q(save = "no")
}

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check for help flag
if ("-h" %in% args || "--help" %in% args) {
  show_help()
}

# Extract package folder path
package_folder <- NA
if ("-d" %in% args) {
  dir_index <- which(args %in% "-d")
  package_folder <- args[dir_index + 1]
} else if (length(args) > 0) {
  package_folder <- args[length(args)]
}

# If no package folder provided, show help
if (is.na(package_folder) || package_folder %in% c("-h", "--help", "-d", "--dir")) {
  cat("Error: Package folder not specified\n")
  show_help()
}

# Read the DESCRIPTION file from the package folder
desc <- read.dcf(file.path(package_folder, "DESCRIPTION"))

# Access by row, then extract the package names from each field
depends_line <- desc[1, "Depends"]
imports_line <- desc[1, "Imports"]
suggests_line <- desc[1, "Suggests"]

# Function to extract package names from a comma-separated string
extract_packages <- function(field) {
  if (!is.na(field) && field != "") {
    packages <- unlist(strsplit(field, ", "))
    packages <- gsub(" .*", "", packages)
    packages <- packages[packages != ""]
    return(packages)
  }
  return(character(0))
}

# Extract package dependencies
dependencies <- extract_packages(depends_line)
imports <- extract_packages(imports_line)
suggests <- extract_packages(suggests_line)

# Combine all dependencies
all_deps <- c(dependencies, imports, suggests)

# Remove system packages (those not from CRAN/Bioconductor)
system_packages <- c("R", "base", "methods", "tools", "utils", "grDevices", 
                     "stats", "graphics")
filtered_deps <- setdiff(all_deps, system_packages)

# Print the packages needed
cat("Packages needed:\n")
print(filtered_deps)
