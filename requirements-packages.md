Write an R-script that, called "packages.R".
The script should:

1. the script supports command line arguments:
   * -h/--help provides a quick usage
   * plain folder name that is the path for the package folder.
   
   If that would make code easier, the folder name may also be
   preceeded with a letter, such as -d/--dir
1. from the package folder, it read the package DESCRIPTION file.
2. extracts all package names the current package depends on
3. removes the system packages
4. for each package in the list, checks if it is already installed,
   and if not, installs it using all cpu cores available.

The script should have shebang in the first line and be executable.

