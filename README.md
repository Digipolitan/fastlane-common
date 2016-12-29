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

## [ensure_git_flow_init](fastlane/actions/ensure_git_flow_init.rb)

This action check if git flow is initialized

```Ruby
ensure_git_flow_init()
```

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

## [get_changelog](fastlane/actions/get_changelog.rb)

Retrieves the last changelog content

```Ruby
changelog = get_changelog()
```

## [get_next_build_number](fastlane/actions/get_next_build_number.rb)

Retrieves the next build number

```Ruby
next_build = get_next_build_number(
  build_number: "789"
)
print next_build # Display 790
```

## [get_next_version_number](fastlane/actions/get_next_version_number.rb)

Retrieves the next version number

```Ruby
next_version = get_next_version_number(
  version_number: "1.0.6",
  bump_type: "minor"
)
print next_version # Display 1.1.0
```

## [git_branch_exists](fastlane/actions/git_branch_exists.rb)

Check if the given branch exists

```Ruby
if git_branch_exists(branch: "release/1.0.1")
  print "Release 1.0.1 branch exists"
end
```

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

## [git_get_develop_branch](fastlane/actions/git_get_develop_branch.rb)

Retrieves the develop branch of your git repository, the default value is **develop**, but can be changed using git-flow

```Ruby
branch = git_get_develop_branch()
print branch
```

## [git_get_master_branch](fastlane/actions/git_get_master_branch.rb)

Retrieves the master branch of your git repository, the default value is **master**, but can be changed using git-flow

```Ruby
branch = git_get_master_branch()
print branch
```

## [git_get_remote_info](fastlane/actions/git_get_remote_info.rb)

This action retrieves information about the git remote

```Ruby
info = git_get_remote_info()
print info[:path]
```

## [git_version_availability](fastlane/actions/git_version_availability.rb)

Validate the version using git tag, ask the user to change the version and the build number if the tag exists

```Ruby
git_version_availability(version_number: "1.1.8")
print Actions.lane_context[SharedValues::GIT_BUILD_TAG]
```
This action update 4 lane_context

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

Helper action, use by your lane to map environment variable, lane_context to options and after that check if all required options are set

```Ruby
lane :sample_lane do |options|
  prepare_lane_options(
    options: options,
    bind_params: [
      Actions::BindParamBuilder.new(:product_name).env_var("PRODUCT_NAME").required().build()
    ]
  )
  print options[:product_name] # The product name will not be nil
end
```

## [user_validation](fastlane/actions/user_validation.rb)

Ask the user to validate informations and merge these informations into environment variable and lane_context

```Ruby
user_validation(
  bind_params: [
    Actions::BindParamBuilder.new("Firstname").lane_context(:TEST_FIRSTNAME).default_value("Jean").build(),
    Actions::BindParamBuilder.new("Lastname").lane_context(:TEST_LASTNAME).required().build()
  ]
)
```
This action update each parameters
