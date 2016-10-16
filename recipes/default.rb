#
# Cookbook Name:: kolla
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'epel-release'
package 'python-pip'

execute 'pip install -U pip'

package 'python-devel'
package 'libffi-devel'
package 'gcc'

execute 'curl -sSL https://get.docker.io | bash'

directory '/etc/systemd/system/docker.service.d' do
  recursive true
end

file '/etc/systemd/system/docker.service.d/kolla.conf' do
  content '[Service]
MountFlags=shared'
end

execute 'systemctl daemon-reload'

service 'docker'

execute 'pip install -U docker-py'

package 'ntp'

service 'ntpd' do
  action :enable
end

service 'ntpd' do
  action :start
end

package 'ansible1.9.noarch'

execute 'pip install kolla'

execute 'cp -r /usr/share/kolla/etc_examples/kolla /etc/'

template '/etc/kolla/globals.yml' do
  source 'globals.yml.erb'
end

execute 'pip install -U python-openstackclient python-neutronclient'

execute 'kolla-build keystone'

execute 'kolla-build glance'

execute 'kolla-genpwd'

execute 'kolla-ansible prechecks'

execute 'kolla-ansible deploy' 
