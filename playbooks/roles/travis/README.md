# Travis Infrastructure Role

This role sets up various infrastructure that is specific to running builds on Travis CI.

## Tasks

* Copies Travis job runner script
* Creates runner output files
* Copies Travis job runner launchd job plist
* Loads Travis job runner launchd job
* Creates a [system-info](https://github.com/travis-ci/system-info) report
