name             'rackspac_elasticsearch'
maintainer       'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license          'Apache 2.0'
description      'Installs and configures elasticsearch'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'ark', '~> 0.2'
depends 'java', '~> 1.18'

recommends 'build-essential'
recommends 'xml'
recommends 'java'
recommends 'monit'

provides 'elasticsearch'
provides 'elasticsearch::data'
provides 'elasticsearch::nginx'
provides 'elasticsearch::proxy'
provides 'elasticsearch::plugins'
provides 'elasticsearch::monit'
provides 'elasticsearch::search_discovery'
