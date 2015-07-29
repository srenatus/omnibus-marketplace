# Add chef-server-ctl marketplace-setup shim for backwards compatability
directory '/opt/opscode/embedded/service/omnibus-ctl' do
  owner 'root'
  group 'root'
  recursive true
  action :create
end

file '/opt/opscode/embedded/service/omnibus-ctl/marketplace_setup.rb' do
  owner 'root'
  group 'root'
  content <<'EOF'
add_command_under_category 'marketplace-setup', 'marketplace', 'Set up the Chef Server Marketplace Appliance', 2 do
  run_command("chef-marketplace-ctl setup #{ARGV[1..-1].join(' ')}")
end
EOF
  action :create
end

motd '50-chef-marketplace-appliance' do
  source 'motd.erb'
  cookbook 'chef-marketplace'
  variables(
    role: 'server',
    support_email: node['chef-marketplace']['support']['email'],
    doc_url: node['chef-marketplace']['documentation']['url']
  )
  action motd_action
end

template '/etc/cron.d/reporting-partition-cleanup' do
  source 'reporting-partition-cleanup.erb'
  variables(
    expression: node['chef-marketplace']['reporting']['cron']['expression'],
    year: node['chef-marketplace']['reporting']['cron']['year'],
    month: node['chef-marketplace']['reporting']['cron']['month']
  )
  action reporting_partition_action
end

package 'cronie' do
  action :install
  only_if { node['chef-marketplace']['reporting']['cron']['enabled'] }
end