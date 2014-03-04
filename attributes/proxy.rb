include_attribute 'elasticsearch::default'
include_attribute 'elasticsearch::nginx'

# Try to load data bag item 'elasticsearch/aws' ------------------
#
begin
  users = Chef::DataBagItem.load('elasticsearch', 'users')[node.chef_environment]['users']
rescue
  users = []
end
# ----------------------------------------------------------------

# === NGINX ===
# Allowed users are set based on data bag values, when it exists.
#
# It's possible to define the credentials directly in your node configuration, if your wish.
#
begin
  default.elasticsearch[:nginx][:port]           = '8080'
  default.elasticsearch[:nginx][:dir]            = ( node.nginx[:dir])
  default.elasticsearch[:nginx][:user]           = ( node.nginx[:user])
  default.elasticsearch[:nginx][:log_dir]        = ( node.nginx[:log_dir])
  default.elasticsearch[:nginx][:users]          = users
  default.elasticsearch[:nginx][:passwords_file] = "#{node.elasticsearch[:path][:conf]}/passwords"
rescue
  default.elasticsearch[:nginx][:dir]            = '/etc/nginx'
  default.elasticsearch[:nginx][:user]           = 'nginx'
  default.elasticsearch[:nginx][:log_dir]        = '/var/log/nginx'
end

# Deny or allow authenticated access to cluster API.
#
# Set this to `true` if you want to use a tool like BigDesk
#
default.elasticsearch[:nginx][:allow_cluster_api] = false

# Allow responding to unauthorized requests for `/status`,
# returning `curl -I localhost:9200`
#
default.elasticsearch[:nginx][:allow_status] = false

# Other Nginx proxy settings
#
default.elasticsearch[:nginx][:client_max_body_size] = '50M'
