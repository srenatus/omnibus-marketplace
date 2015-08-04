add_command_under_category 'test', 'Configuration', 'Test that the Chef Server Marketplace addtions are working properly', 2 do
  statuses = []

  ctl_rspec = [
    'cd /opt/chef-marketplace &&',
    '/opt/chef-marketplace/embedded/bin/rake spec'
  ].join(' ')

  statuses << run_command(ctl_rspec).exitstatus

  # If the Chef Server has been set up make sure the ctl commands work
  if File.exist?('/etc/opscode/chef-server-running.json')
    setup_cmd = [
      'chef-server-ctl marketplace-setup',
      '-f john',
      '-l doe',
      '-e john@doe.dead',
      '-u johndoedeadcheftest',
      '-o johhdoedeadcheftestorg',
      '-p password',
      '--yes'
    ].join(' ')

    statuses << run_command(setup_cmd).exitstatus

    # verify that the user and org were created
    statuses << run_command('chef-server-ctl org-show johhdoedeadcheftestorg').exitstatus
    statuses << run_command('chef-server-ctl user-show johndoedeadcheftest').exitstatus

    # clean up
    statuses << run_command('chef-server-ctl org-delete johhdoedeadcheftestorg -y').exitstatus
    statuses << run_command('chef-server-ctl user-delete johndoedeadcheftest -y').exitstatus
  end

  exit(statuses.all? { |s| s == 0 } ? 0 : 1)
end
