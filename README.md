# App Release for Rails

A simple tool for updating the version of a Rails application.

This library was implemented to simplify project versioning. With this tool can store, quickly create and push tags.

## Installation

```ruby
gem 'app-release', require: false
```

## Using

### Create a version file

```shell
bundle exec app_release --init
```

### Version upgrade

```shell
# Original version: 2.4.6

bundle exec app_release --patch # => 2.4.7

bundle exec app_release --minor # => 2.5.0

bundle exec app_release --major # => 3.0.0
```

### Version upgrade and git tag creation

```shell
bundle exec app_release --minor --create-git-tag
```

If need to create a tag in a specific directory, then need to use the following command:

```shell
bundle exec app_release --minor --create-git-tag-for dev
```

If need to push after creation, then:

```shell
bundle exec app_release --minor --create-git-tag-for dev --git-push
```
