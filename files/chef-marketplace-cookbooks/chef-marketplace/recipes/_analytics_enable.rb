directory '/etc/opscode-analytics/' do
  owner 'root'
  group 'root'
  action :create
end

template '/etc/cron.d/actions-trimmer' do
  trimmer = node['chef-marketplace']['analytics']['trimmer']
  source 'actions-trimmer.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    interval: trimmer['interval'],
    db_size: trimmer['max_db_size'],
    log_file: trimmer['log_file']
  )
  action actions_trimmer_action
end
