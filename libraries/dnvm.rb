module Dotnetframework
  class DNVM
    attr_accessor :dnvm_cmd_path 
  
    require 'chef/mixin/shell_out'
    include Chef::Mixin::ShellOut  
    
    def initialize()
      @dnvm_cmd_path = "#{ENV['SystemDrive']}/Program Files/dnvm"
    end
    
    def is_specific_dnx_version_available?(version, architecture)
      puts 'starting function'
      cmd = "\"#{dnvm_cmd_path}/dnvm\" list -PassThru"
      puts "running command #{cmd}" 
      cmd = shell_out(cmd)
      raise cmd.stderr if !cmd.stderr.empty?()
    
      hash = Hash.new
      puts 'starting parsing'
      ## Output which we're parsing
      # Alias           :
      # Version         : 1.0.0-rc1-update1
      # Architecture    : x64
      # OperatingSystem : win
      # Location        : C:\Users\abrehm\.dnx\runtimes
      # Active          : True
      # Runtime         : clr

      # Alias           : default
      # Version         : 1.0.0-rc1-update1
      # Architecture    : x86
      # OperatingSystem : win
      # Location        : C:\Users\abrehm\.dnx\runtimes
      # Active          : False
      # Runtime         : clr
      ##
      cmd.stdout.lines.each do |line|
        match = line.gsub(/\s+/,'').split(':') # word : word?
        next if !match.any? # empty line or something, we're skipping.
        
        hash = Hash.new if (match.first == 'Alias') # Starting over.
        hash[match.first] = match.last
        if (hash['Version'] == version && hash['Architecture'] == architecture)
          puts "version #{version} and architecture #{architecture} found. Returning true"
          return true
        end
      end
      puts 'nothing found, returning false'
      return false
    end
  end
end