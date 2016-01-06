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

# If the recipe is already installed.
unless ENV['DNX_HOME'].nil? do
  # Clean up after ourselves.
  directory 'c:/windows/temp/dnvm' do
    action :delete
  end
  
  return # Continue the rest of the run
end

directory 'c:/windows/temp/dnvm' do
  action :create
end

remote_file 'c:/windows/temp/dnvm/dnvm.ps1' do
  source 'https://raw.githubusercontent.com/aspnet/Home/dev/dnvm.ps1'
  action :create
end

remote_file 'c:/windows/temp/dnvm/dnvm.cmd' do
  source 'https://raw.githubusercontent.com/aspnet/Home/dev/dnvm.cmd'
  action :create
end

#TODO: Better error handling, but dnvm will iterate a few more times before it settles down, so I expect the errors will too
ruby_block 'Install DNVM' do
  block do
    require 'mixlib/shellout'
    cmd = Mixlib::ShellOut.new('dnvm.cmd setup', :cwd => 'c:/windows/temp/dnvm')
    cmd.run_command
    begin
      cmd.error!
    rescue
      raise 'Error when attempting to install DNVM - ' + cmd.stderr
    end
  end
end
