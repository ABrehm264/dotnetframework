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
# Description: Installs the specified verison of the .Net execution environment
include_recipe 'dotnetframework::dotnet-versionmanager'

full_name                        = node['dotnetframework']['dnx-version']
version                          = node['dotnetframework']['dnx'][full_name]['version']
architecture                     = node['dotnetframework']['dnx'][full_name]['architecture']

# Installs the specified framework to the global path for all users
ruby_block "Install DNX #{version}" do
  block do
    require 'mixlib/shellout'
    puts "attempting to install stuffz"
    cmd = Mixlib::ShellOut.new("\"#{Dotnetframework::DNVM::DNVM_CMD_PATH}/dnvm.cmd\" install \"#{version}\" -arch \"#{architecture}\" -g", :cwd => "#{ENV['SystemDrive']}")
    puts "running command #{cmd.command}"
    cmd.run_command
    raise "Error when attempting to install dnx framework #{version} - #{cmd.stderr}" if !cmd.stderr.to_s.empty?
  end
  not_if { Dotnetframework::DNVM.new().is_specific_dnx_version_available?(version, architecture) }
end
