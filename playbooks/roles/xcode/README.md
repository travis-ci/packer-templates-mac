# Xcode Role

This role installs Xcode and the iOS simulator runtimes using [xcode-install](https://github.com/KrauseFx/xcode-install).

## Variables

* `xcode_version`: The version of Xcode to install. Will be passed in to `xcversion install`. (required)
* `xcode_install_user`: The Apple ID to use to log in to Apple's Developer Portal. (required)
* `xcode_install_password`: The password to use to log in to Apple's Developer Portal. (required)
* `system_gem_dir`: The `GEM_HOME` for the system Ruby installation. (optional, default: `/Library/Ruby/Gems/2.3.0`)

## Tasks

* Installs the xcode-install gem
* Installs Xcode
* Installs all available simulator runtimes for the installed Xcode version

## Notes

This role takes a very long time. Modern Xcodes can install and run simulator versions as old as iOS 8, which is four years old at time of writing and amounts to 36 different runtimes. Each one takes several minutes to install, and since they use the macOS package installer, they can't be run in parallel.

The simulator tasks have the `simulators` tag attached to them. If you want to test something about your playbook that does not require the simulator runtimes to be installed, you can pass `--skip-tags simulators` to `ansible-playbook` for a much quicker run.
