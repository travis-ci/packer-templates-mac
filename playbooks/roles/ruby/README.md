# Ruby Role

This role ensures the right Ruby versions are present, and installs a few gems by default.

## Variables

* `rubies`: A list of Ruby versions to install with RVM. (optional, default: 2.4.3, 2.3.5)
* `default_ruby`: The Ruby version to set as the default version. (optional, default: 2.4.3)
* `global_rubygems`: A list of gems to install in each of the installed Ruby versions. (optional: see `defaults/main.yml` for default list)
* `rvm_binary`: The location of the RVM binary. (optional, default: /Users/travis/.rvm/bin/rvm)

  > **Note:** Setting `rvm_binary` will not cause RVM to be installed into a different location. The variable exists as a convenience for tasks that need to call the `rvm` command to avoid repetition. You almost certainly should not override it in your playbook.

## Tasks

* Installs the GPG Homebrew package
* Imports GPG keys for RVM
* Installs RVM
* Configures RVM to look for Travis CI Ruby binaries
* Installs Ruby versions
* Sets the default Ruby
* Installs Ruby gems into each Ruby version
* Configures RubyGems to not install documentation for gems

## Notes

We force RVM to install only binary Ruby versions. This makes the build faster than if they end up having to be built from source, and it helps ensure that the image is provisioned in a way that is compatible with [the existing Ruby binaries that Travis builds](https://rubies.travis-ci.org/), as that's what our users will get when they run jobs.
