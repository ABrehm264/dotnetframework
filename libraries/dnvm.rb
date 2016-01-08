module Dotnetframework
  class DNVM
    attr_accessor :dnvm_cmd_path 
  
    require 'chef/mixin/shell_out'
    include Chef::Mixin::ShellOut  
    
    def initialize()
      @dnvm_cmd_path = "#{ENV['SystemDrive']}/Program Files/dnvm"
    end
    
    def is_specific_dnx_version_available?(version, architecture)
      puts 'starting function\n'
      cmd = shell_out("\"#{dnvm_cmd_path}/dnvm\" list")
      raise cmd.stderr if !cmd.stderr.empty?()
    
      puts 'starting parsing'
      cmd.stdout.lines.each do |line|
        next if line.include? 'Active'
        next if line.include? '------'
        return true if line.include? version and line.include? architecture
        puts 'couldnt find anything\n'
      end
      puts 'nothing found, returning false\n'
      return false
    end
  end
end