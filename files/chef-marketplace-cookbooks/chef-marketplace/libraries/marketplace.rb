## Copyright:: Copyright (c) 2015 Chef Software, Inc.
## License:: Apache License, Version 2.0
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

require 'mixlib/config'
require 'chef/mash'

class Marketplace
  extend Mixlib::Config

  config_context :motd do
    default :enabled, true
  end

  config_context :support do
    default :email, 'aws@chef.io'
  end

  config_context :documentation do
    default :url, 'https://docs.chef.io/aws_marketplace.html'
  end

  # Which port and FQDN the Chef Server LB will listen on
  default :api_fqdn, nil
  default :api_ssl_port, 443

  # How many nodes are licensed
  default :license_count, 5

  # Which role the marketplace addition is to play:
  # 'server', 'aio', 'analytics', 'compliance'
  default :role, 'server'

  # The marketplace platform, eg: 'aws', 'openstack', 'azure', 'gce', etc.
  default :platform, 'aws'

  # The default SSH user
  default :user, 'ec2-user'

  # The reckoner billing daemon
  config_context :reckoner do
    default :enabled, false
    default :free_node_count, 5

    # AWS specific config
    configurable :product_code
    default :region, 'us-east-1'
    default :usage_dimension, 'ProvisionedHosts'
  end

  # Set to true if you don't want to use outbound networks, eg: package mirrors
  default :disable_outboud_traffic, false

  config_context :security do
    # Force enable or disable the security recipe
    default :enabled, false
  end

  config_context :reporting do
    config_context :cron do
      default :enabled, true

      # Standard crontab expression
      default :expression, '0 0 * * *'

      # Up to what year to delete, must be a valid shell command
      default :year, 'date +%Y'

      # Up to what month to delete, must be a valid shell command
      default :month, 'date +%m'
    end
  end

  config_context :analytics do
    default :ssl_port, 8443

    config_context :trimmer do
      default :enabled, true

      # How often in hours to run the trimmer (1-24)
      default :interval, 4

      default :log_file, '/var/log/opscode-analytics/actions-trimmer.log'

      # The allowed max size of the actiongs database in Gigs
      default :max_db_size, 1
    end
  end

  config_context :compliance do
    default :ssl_port, 443
  end

  config_context :marketplace_api do
    default :address, 'https://marketplace.chef.io'
  end

  # Deprecated config options
  def self.publishing
    puts 'WARNING: The publishing config option is no longer used and will be removed in a future release'
    puts 'WARNING: Please remove all references to it /etc/chef-marketplace/marketplace.rb'
    @publishing ||= Mash.new
    @publishing
  end
end
