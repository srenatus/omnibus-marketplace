# Chef Marketplace Changelog

# 0.0.5 (UNRELEASED)
## omnibus-marketplace
* Update README.md
* Use cloud-init to configure instances at boot time
* 'preconfigure' marketplace images to make setup times shorter
* Add reckoner

## chef-marketplace-ctl
* Add chef-marketplace-ctl register-node command
* Add --preconfigure switch to chef-marketplace-ctl setup
* Use standard omnibus-ctl to get service commands
* Add chef-marketplace-ctl prepare-for-publishing command

## chef-marketplace-gem
* Add Marketplace Api client
* Add Node registration to setup
* Update setup to support preconfiguring
* Add initial reckoner support

## chef-marketplace-cookbooks
* Add node registration recipe
* Add marketplace_api config context to marketplace.rb
* Add preconfigure recipes
* Add reckoner and runit recipes
* Restructure common, security, and publishing recipes for the new publish command

# 0.0.4 (2015-11-09)
## omnibus-marketplace
* Add shim server-plugin cookbooks to please the Chef Server plugin design

## chef-marketplace-cookbooks
* Remove converging chef-marketplace cookbooks during chef-server-ctl reconfigure

# 0.0.3 (2015-11-03)
## omnibus-marketplace
* Add chef-marketplace-gem
* Add initial support for RHEL, Oracle, and Ubuntu 14.04
* Update Ruby to 2.2.3
* Update Rubygems to 2.4.8
* Update Chef gem to use master

## chef-marketplace-gem
* Add initial Chef Compliance support

## chef-marketplace-ctl
* Add chef-compliance to upgrade command
* Refactor upgrade command to use a single chef run
* Dynamically link ctl commands depending on configured role

## chef-marketplace-cookbooks
* Refactor upgrade recipe

# 0.0.2 (2015-09-09)
## omnibus-marketplace
* Add CHANGELOG.md
* Update README.md
* Remove 'chef-marketplace' software definition
* Add sequel gem
* Add postgresql client

## chef-marketplace-ctl
* Add chef-marketplace-ctl hostname command
* Add chef-marketplace-ctl trim-actions-db command
* Update setup UI to be colorized
* Update upgrade command tests
* Update several command descriptions
* Update the upgrade command to verify that package mirrors are reachable
* Use socketless chef-zero to avoid port collisions
* Bug fixes

## chef-marketplace-cookbooks
* Add All-In-One mode support
* Refactor chef-marketplace to use the new Chef Server plugin registration
* Update chef-ingredient cookbook
* Add 'api_fqdn', 'license_count', 'security' and 'analytics' options to
  marketplace.rb config
* Move FQDN detection from setup command into the marketplace cookbook
* Refactor recipe structure
* Bug fixes

# 0.0.1 (2015-08-10)
## omnibus-marketplace
* Add initial project and software definitions
* Add LICENSE
* Update README.md

## chef-marketplace-ctl
* Add chef-marketplace-ctl upgrade command
* Add chef-marketplace-ctl test command
* Add chef-marketplace-ctl setup command
* Add rake task for running tests and linting
* Add unit and functional tests for commands
* Bug fixes

## chef-marketplace-cookbooks
* Port marketplace_image cookbook chef-marketplace
* Add `disable_outbound_traffic` config option
* Add OpenStack plaform support
* Manage /etc/hosts via cloud-init
* Add automatic reporting database pruning
* Bug fixes
