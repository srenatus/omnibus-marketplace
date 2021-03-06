include_recipe 'chef-marketplace::config'

if outbound_traffic_disabled?
  Chef::Log.warn 'Skipping node registration because outbound traffic is disabled'
  return
end

ruby_block 'register node' do
  block do
    require 'marketplace/api_client'

    # Build a valid params hash
    #  {
    #    'user' => {
    #      'first_name' => 'foo',
    #      'last_name' => 'bar',
    #      'email' => 'foo@bar.com'
    #      'organization' => 'Acme, Inc.'
    #    },
    #    'node' => {
    #      'platform' => 'aws',
    #      'platform_uuid' => 'i-1234abc',
    #      'role' => 'compliance',
    #      'license' => '25'
    #    }
    #  }

    params = { 'user' => {}, 'node' => {} }

    # User info gets pulled in from chef-marketplace-ctl register-node
    params['user'] = node['chef-marketplace']['registration'].to_hash

    params['node']['license'] = node['chef-marketplace']['license_count'].to_s
    params['node']['platform'] = node['chef-marketplace']['platform']
    params['node']['role'] = node['chef-marketplace']['role']
    params['node']['platform_uuid'] =
      begin
        case node['cloud_v2']['provider']
        when 'gce'
          node['gce']['instance']['id']
        when 'ec2'
          node['ec2']['instance_id']
        else # azure, etc..
          node['chef-marketplace']['api_fqdn']
        end
      rescue
        node['chef-marketplace']['api_fqdn']
      end

    client = Marketplace::ApiClient.new(params['user'].delete('address'))
    res = client.post('/nodes/register', params)
    fail res.message unless (200...400).include?(res.code.to_i)
  end
end
