fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### multi_environment
```
fastlane multi_environment
```
Execute a lane using different environment variables

#### Options

* __**target_lane**__: The target lane to execute with different environment

  * **environment_variable**: TARGET_LANE

  * **type**: string

  * **optional**: false

#### Environment variables

* __**ENVIRONMENT_DIRECTORY_PATH**__: The directory path of the environment info

  * **type**: string

  * **optional**: true



----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
