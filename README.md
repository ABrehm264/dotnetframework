# Dotnetframework cookbook

Installs and configures the .NET framework 4, 4.5, 4.5.1, 4.5.2, or 4.6 runtime

# Requirements

Tested on Windows Server 2008 R2 and Windows Server 2012R2. The selected .NET
runtime should work on versions of Windows supported by the associated .NET
installer.

* Windows 2008
* Windows 2008 R2
* Windows 2012
* Windows 2008 R2

# Usage

Include the default recipe in your run list. The default recipe will install
the specified .NET framework version.

# Attributes

## default

* `node['dotnetframework']['version']` - defaults to '4.5.2' Acceptable values:
'4.0', '4.5', '4.5.1', '4.5.2', '4.6', '4.6.1'.
* `node['dotnetframework']['dnx-version']` - For use with the dnx recipe. Used to specify the dot execution environment version to install in the .net version manager. Defaults to '1.0.0-rc1-update1' Acceptable values:
'1.0.0-rc1-update1'.

# Recipes

## default

Installs the .NET Framework.

## regiis

This recipe register .NET with IIS so that IIS can host .NET application
associated with the specified intalled .NET version. This recipe currently
does not support Windows 2012 or higher. For Windows 2012 or newer its
recommended that you use the IIS cookbook to register the .NET version.

## dnx

Installs the version of the .Net execution environment specfied by the `default['dotnetframework']['dnx-version']` attribute in the .Net version manager. If the .Net Version manager is not installed, it will be.

## dotnet-versionmanger

Installs the .Net Version Manager. https://github.com/aspnet/dnvm

# Helper Recipes

## dotnet-4-6-1

Installs .Net 4.6.1. This is an alternative to running the default recipe with the version attribute set to 4.6.1.

usage:
include_recipe 'dotnetframework::dotnet-4-6-1'

## dnx-1-0-0-rc1-update1

Installs the dnx-1-0-0-rc1-update1 execution environment into the .net version manager.

usage:
include_recipe 'dotnetframework::dnx-1-0-0-rc1-update1'

## mini-tests

You can include the mini-tests in your runlist to verify .NET was successfully
installed, however .NET will not work until you reboot.

.NET 4.6 minitests will fail until you reboot, so its best to run Chef with
only dotnetframework in your runlist, reboot, then include dotnetframework
again with the minitest-handler.

# TODO

- Install .NET using the windows_feature resource if the current OS supports it.
- Support older versions of .NET < 4.0.
- Support installation over WinRM (i.e. native scheduled task support).
- Abstract .NET installation to a Chef resource.

# Author

Author:: Shawn Neal (sneal@sneal.net)
