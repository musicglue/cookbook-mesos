#
# Cookbook Name:: mesos
# Recipe:: docker
#
# Copyright 2013, Music Glue
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'docker'

package 'python-setuptools'

directory '/var/lib/mesos/executors' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

remote_file '/var/lib/mesos/executors/docker' do
  owner 'root'
  group 'root'
  source 'https://raw.github.com/mesosphere/mesos-docker/master/bin/mesos-docker'
  mode 00755
  not_if { ::File.exists?('/var/lib/mesos/executors/docker') }
end

remote_file "#{Chef::Config[:file_cache_path]}/mesos.egg" do
  owner 'root'
  group 'root'
  source 'http://downloads.mesosphere.io/master/ubuntu/13.04/mesos-0.14.0-py2.7-linux-x86_64.egg'
  mode 00755
  not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/mesos.egg") }
end

bash 'install-mesos-egg' do
  user 'root'
  group 'root'
  code <<-EOH
    easy_install "#{Chef::Config[:file_cache_path]}/mesos.egg"
  EOH
  not_if { ::File.exists?('/usr/local/lib/python2.7/dist-packages/mesos.egg') }
end
