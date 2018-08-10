# Homebrew Role

This role ensures Homebrew, as well as several Homebrew casks and packages are installed.

## Variables

* `homebrew_packages`: The list of Homebrew packages that should be installed. (optional, see `defaults/main.yml` for default list)
* `homebrew_casks`: The list of Homebrew casks that should be installed. (optional, see `defaults/main.yml` for default list)

## Tasks

* Install Homebrew
* Install Homebrew casks and packages

## Notes

In this role, casks are installed before ordinary packages. The reason is that by default, we install the `maven` package, and it requires Java to be present, which is one of the casks we install. Currently, it works well enough to just install casks first. If the requirements ever get more interesting, we may need to make this role more complex.
