windows = (PLATFORM =~ /win32|cygwin/) rescue nil
sudo = windows ? "" : "sudo"
repos = %w[core more plugins].collect {|r| "merb-#{r}"}

# Usage: sake merb:clone
desc "Clone a copy of all 3 of Merb's repositories"
task 'merb:clone' do
  if File.exists?("merb")
    puts "./merb already exists!"
    exit
  end
  require 'fileutils'
  mkdir "merb"
  cd "merb"
  repos.each do |r|
    sh "git clone git://github.com/wycats/#{r}.git"
  end
end

# Usage: sake merb:update
desc "Update your local Merb repositories.  Run from inside the top-level merb directory."
task 'merb:update' do
  repos.each do |r|
    unless File.exists?(r)
      puts "#{r} missing ... did you use merb:clone to set this up?"
      exit
    end
  end
  
  repos.each do |r|
    cd r
    sh "git fetch"
    sh "git rebase origin/master"
    cd ".."
  end
end

# Usage: sake merb:gems:wipe
desc "Uninstall all RubyGems related to Merb"
task 'merb:gems:wipe' do
  gems = %x[gem list merb]
  gems.split("\n").each do |line|
    next unless line =~ /^(merb[^ ]+)/
    sh "#{sudo} gem uninstall -a -i -x #{$1}"
  end
end

# Usage: sake merb:install:core
desc "Install merb-core"
task 'merb:install:core' do
  cd 'merb-core'
  sh "rake install"
  cd '..'
end

# Usage: sake merb:install:more
desc "Install merb-more"
task 'merb:install:more' do
  cd 'merb-more'
  sh "rake install"
  cd '..'
end

# Usage: sake merb:install
desc "Install merb-core and merb-more"
task 'merb:install' => ["merb:install:core", "merb:install:more"]