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
# Description: Installs the .Net Version Manager
install_path = Dotnetframework::DNVM::DNVM_CMD_PATH

ruby_block "Create #{install_path}" do
  block do
    FileUtils.mkdir_p install_path
  end
  not_if { Dir.exists? install_path }
end

remote_file "#{install_path}/dnvm.ps1" do
  source 'https://raw.githubusercontent.com/aspnet/Home/dev/dnvm.ps1'
  action :create
end

remote_file "#{install_path}/dnvm.cmd" do
  source 'https://raw.githubusercontent.com/aspnet/Home/dev/dnvm.cmd'
  action :create
end

# Add the install path to the Path environment variable so that it can be accessed globally.
install_path_recreate = install_path + '' # Recreating the string since it seems that this operation changes the passed in string.
env "path" do
  delim ";"
  value install_path_recreate
  action :modify
end
