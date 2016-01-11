module Dotnetframework
  class DNVM
    DNVM_CMD_PATH = "#{ENV['SystemDrive']}/Program Files/dnvm/bin" 
  
    require 'chef/mixin/shell_out'
    include Chef::Mixin::ShellOut  
    
    def is_specific_dnx_version_available?(version, architecture)
      cmd = "\"#{DNVM_CMD_PATH}/dnvm\" list -PassThru"
      puts "Running command #{cmd}"
      cmd = shell_out(cmd)
      raise cmd.stderr if !cmd.stderr.empty?()
    
      puts "Parsing output"
      hash = Hash.new
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
        match = line.gsub(/\s+/,'').split(':')
        next if !match.any? # empty line or something, we're skipping.
        
        hash = Hash.new if (match.first == 'Alias') # Starting over.
        
        hash[match.first] = match.last
        if (hash['Version'] == version && hash['Architecture'] == architecture)
          puts "found version returning true"
          return true 
        end
      end
      puts "did not find version returning false."
      return false
    end
  end
end
