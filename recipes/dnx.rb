# encoding: UTF-8
#
# Author:: Alex Brehm (<ABrehm264@gmail.com>)
# Cookbook Name:: dotnetframework
# Recipe:: dotnet_4_0
#
# Copyright::
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
#
# Description: Installs the specified verison of dnvm
include_recipe 'dotnetframework::dotnet-dnvm'

version   = node['dotnetframework']['dnx-version']
full_name = node['dotnetframework']['dnx'][version]['full_name']

# Installs the specified framework to the global path for all users
ruby_block "Install DNX #{version}" do
  block do
    require 'mixlib/shellout'
    cmd = Mixlib::ShellOut.new("dnvm install #{version} -g", :cwd => 'c:/windows/temp')
    cmd.run_command
    begin
      cmd.error!
    rescue
      raise 'Error when attempting to install DNVM - ' + cmd.stderr
    end
  end
  notifies :request, 'windows_reboot[60]', :immediately
  not_if ENV['PATH'].include? full_name
end
