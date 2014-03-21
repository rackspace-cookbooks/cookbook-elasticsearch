#
# Cookbook Name:: elasticsearch
#
# Copyright 2014, Rackspace, UK, Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'rackspace_elasticsearch::default' do
  elasticsearch_test_platforms.each do |platform, versions|
    describe "on #{platform}" do
      versions.each do |version|
        describe version do
          before :each do
            stub_command('test -d /usr/local/elasticsearch').and_return(true)
            stub_command('test -L /usr/local/elasticsearch').and_return(true)
          end
          let(:chef_run) do
            ChefSpec::Runner.new do |node|
              node.automatic['memory']['total'] = '512kB'
            end.converge(described_recipe)
          end
          it 'include the default recipe' do
            expect(chef_run).to include_recipe 'rackspace_elasticsearch::default'
          end
          it 'installs make package' do
            expect(chef_run).to install_package('make')
          end
          it 'installs libtool package' do
            expect(chef_run).to install_package('libtool')
          end
          it 'installs autoconf package' do
            expect(chef_run).to install_package('autoconf')
          end
          it 'installs unzip package' do
            expect(chef_run).to install_package('unzip')
          end
          it 'installs rsync package' do
            expect(chef_run).to install_package('rsync')
          end
          it 'installs autogen package' do
            expect(chef_run).to install_package('autogen')
          end
          it 'installs gcc package' do
            expect(chef_run).to install_package('gcc')
          end
          it 'installs curl package' do
            expect(chef_run).to install_package('curl')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('/etc/init.d/elasticsearch')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('elasticsearch-env.sh')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('elasticsearch.yml')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('logging.yml')
          end
          it 'populate the /usr/local/etc/elasticsearch directory' do
            expect(chef_run).to create_directory('/usr/local/etc/elasticsearch')
          end
          it 'populate the /usr/local/var/run/elasticsearch directory' do
            expect(chef_run).to create_directory('/usr/local/var/run/elasticsearch')
          end
          it 'populate the /usr/local/var/log/elasticsearch directory' do
            expect(chef_run).to create_directory('/usr/local/var/log/elasticsearch')
          end
          it 'populate the /usr/local/var/data/elasticsearch directory' do
            expect(chef_run).to create_directory('/usr/local/var/data/elasticsearch')
          end
          it 'creates the elasticsearch group' do
            expect(chef_run).to create_group('elasticsearch')
          end
          it 'creates the elasticsearch user' do
            expect(chef_run).to create_user('elasticsearch')
          end
          it 'creates the /etc/security/limits.d/10-elasticsearch.conf file' do
            expect(chef_run).to create_file('/etc/security/limits.d/10-elasticsearch.conf')
          end
          it 'enable service elasticsearch' do
            expect(chef_run).to enable_service('elasticsearch')
          end
          it 'validate log writes increase limits for the elasticsearch user' do
            expect(chef_run).to write_log('increase limits for the elasticsearch user')
          end
        end
      end
    end
  end
end
