name 'chef-marketplace-cookbooks'

source path: "#{project.files_path}/#{name}"

dependency 'berkshelf'
dependency 'chef-marketplace-gem'

build do
  command "#{install_dir}/embedded/bin/berks vendor #{install_dir}/embedded/cookbooks --berksfile=./chef-marketplace/Berksfile",
          env: { 'RUBYOPT'         => nil,
                 'BUNDLE_BIN_PATH' => nil,
                 'BUNDLE_GEMFILE'  => nil,
                 'GEM_PATH'        => nil,
                 'GEM_HOME'        => nil }

  erb source: 'single-recipe.json.erb',
      dest: "#{install_dir}/embedded/cookbooks/dna.json",
      vars: { recipe: 'chef-marketplace::default' }

  erb source: 'single-recipe.json.erb',
      dest: "#{install_dir}/embedded/cookbooks/show-config.json",
      vars: { recipe: 'chef-marketplace::show_config' }

  erb source: 'solo.rb.erb',
      dest: "#{install_dir}/embedded/cookbooks/solo.rb"
end
