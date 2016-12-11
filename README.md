Digipolitan fastlane-common
================

Create common actions used by sub Digipolitan fastlane-repositories

## Installation
To install fastlane, simply use gem:

```
[sudo] gem install fastlane
```

# Available Fastlane Lanes
All lanes available are described [here](fastlane/README.md)

# Available Fastlane actions

## [files_matching](fastlane/actions/files_matching.rb)

This action return an array of files matching with the given pattern

```Ruby
files = files_matching(
  pattern: "*.txt",
  directory: "./assets"
)
print files.length + " txt files"
```
This command search all files with txt extension on the assets directory

## [git_flow_release](fastlane/actions/git_flow_release.rb)

This action execute a git flow release command

```Ruby
git_flow_release(
  action: "start",
  name: "1.0.5"
)
```
Start a new release version 1.0.5 on your git repository

```Ruby
git_flow_release(
  action: "finish",
  name: "1.0.5"
)
```
Complete the release version 1.0.5 on your git repository

## [git_get_remote_info](fastlane/actions/git_get_remote_info.rb)

This action retrieves information about the git remote

```Ruby
info = git_get_remote_info()
print info[:path]
```

## [new_changelog_version](fastlane/actions/new_changelog_version.rb)

Adds to the changelog file the content of the new version

```Ruby
new_changelog_version(
  product_name: "MyApp",
  version: "1.0.5"
  content: "new feature available !"
)
```

## [prepare_lane_options](fastlane/actions/prepare_lane_options.rb)

Helper action, use by your lane to map environment variable to options and after that check if all required options are set

```Ruby
lane :sample_lane do |options|
  prepare_lane_options(
    options: options,
    mapping: {
      :product_name => {:env_var => "DG_PRODUCT_NAME"}
    },
    required_keys: [
      :product_name
    ]
  )
  print options[:product_name] # The product name will not be nil
end
```
