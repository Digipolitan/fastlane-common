Digipolitan Fastlane common
================

Create common lanes used by sub Digipolitan repository

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

## [git_get_origin_info](fastlane/actions/git_get_origin_info.rb)

This action retrieves information about the git remote

```Ruby
info = git_get_origin_info()
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

Helper action, use by your lane to check if all required parameters are set and to map environment variable to parametes

```Ruby
new_changelog_version(
  product_name: "MyApp",
  version: "1.0.5"
  content: "new feature available !"
)
```
prepare_lane_options(
    options: options,
    mapping: {
      :workspace => {:env_var => "DG_WORKSPACE"},
      :project => {:env_var => "DG_PROJECT"},
      :scheme => {:env_var => "DG_SCHEME"}
    }
  )
