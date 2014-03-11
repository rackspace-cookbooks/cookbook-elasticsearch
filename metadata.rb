name             'rackspace_elasticsearch'
maintainer       'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license          'Apache 2.0'
description      'Installs and configures elasticsearch'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'ark', '~> 0.2'
depends 'java', '~> 1.18'
depends 'rackspace_elasticsearch::curl'
depends 'rackspace_elasticsearch::nginx'
recommends 'build-essential'
recommends 'xml'
recommends 'java'
recommends 'monit'

provides 'rackspace_elasticsearch'
provides 'rackspace_elasticsearch::data'
provides 'rackspace_elasticsearch::nginx'
provides 'rackspace_elasticsearch::proxy'
provides 'rackspace_elasticsearch::plugins'
provides 'rackspace_elasticsearch::monit'
provides 'rackspace_elasticsearch::search_discovery'
