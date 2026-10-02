#!/usr/bin/env Rscript

# Read the DESCRIPTION file
desc <- read.dcf("DESCRIPTION")

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
