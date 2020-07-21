```shell
gem build app_release.gemspec

gem push app-release-1.0.1.gem

gem push --key github --host https://rubygems.pkg.github.com/afuno app-release-1.0.1.gem
```
