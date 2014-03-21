# Module Extensions
module Extensions
  # Install an Elasticsearch plugin
  #
  # In the simplest form, just pass a plugin name in the GitHub <user>/<repo> format:
  #
  #     install_plugin 'karmi/elasticsearch-paramedic'
  #
  # You may also optionally pass a version:
  #
  #     install_plugin 'elasticsearch/elasticsearch-mapper-attachments', 'version' => '1.6.0'
  #
  # ... as well as the URL:
  #
  #     install_plugin 'hunspell', 'url' => 'https://github.com/downloads/.../elasticsearch-analysis-hunspell-1.1.1.zip'
  #
  # The "elasticsearch::plugins" recipe will install all plugins listed in
  # the role/node attributes or in the data bag (`node.elasticsearch.plugins`).
  #
  # Example:
  #
  #     { elasticsearch: {
  #         plugins: {
  #           'karmi/elasticsearch-paramedic' => {},
  #           'lukas-vlcek/bigdesk'           => { 'version' => '1.0.0' },
  #           'hunspell'                      => { 'url' => 'https://github.com/downloads/...' }
  #         }
  #       }
  #     }
  #
  # See <http://wiki.opscode.com/display/chef/Setting+Attributes+(Examples)> for more info.
  #
  def install_plugin(name, params = {})
    ruby_block "Install plugin: #{name}" do
      block do
        version = params['version'] ? "/#{params['version']}" : nil
        url     = params['url']     ? " -url #{params['url']}" : nil
        command = Mixlib::ShellOut.new("/usr/local/bin/plugin -install #{name}#{version}#{url}")
        command.run_command
        command.error!
        Chef::Log.debug command

        # Ensure proper permissions
        command = Mixlib::ShellOut.new("chown -R #{node.elasticsearch[:user]}:#{node.elasticsearch[:user]} .
        command >> #{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/")
        command.run_command
        command.error!
      end

      notifies :restart, 'service[elasticsearch]' unless node.elasticsearch[:skip_restart]

      not_if do
        begin
          Dir.entries("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/").any? do |plugin|
            next if plugin =~ /^\./
            name.include? plugin
          end
        rescue
          name = false
        end
      end

    end
  end
end
