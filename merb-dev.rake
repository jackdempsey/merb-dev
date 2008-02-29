# Usage: sake merb:clone
desc "Clone a copy of all 3 of the Merb repositories"
task 'merb:clone' do
  if File.exists?("merb")
    puts "./merb already exists!"
    exit
  end
  require 'fileutils'
  mkdir "merb"
  cd "merb"
  %w[core more plugins].collect {|r| "merb-#{r}"}.each do |r|
    sh "git clone git://github.com/wycats/#{r}.git"
  end
end

# Usage: sake merb:update
desc "Update your local Merb repositories.  Run from inside the top-level merb directory."
task 'merb:update' do
  repos = %w[core more plugins].collect {|r| "merb-#{r}"}
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
  windows = (PLATFORM =~ /win32|cygwin/) rescue nil
  sudo = windows ? "" : "sudo"
  gems = %x[gem list merb]
  gems.split("\n").each do |line|
    next unless line =~ /^(merb[^ ]+)/
    sh "#{sudo} gem uninstall -a -i -x #{$1}"
  end
end

# Usage: sake merb:gems:refresh
desc "Pull fresh copies of Merb and refresh all the gems"
task 'merb:gems:refresh' => ["merb:update", "merb:install"]

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

# Usage: sake merb:sake:refresh
desc "Remove and reinstall Merb sake recipes"
task "merb:sake:refresh" do
  %w[clone update gems:wipe gems:refresh
    install install:core install:more sake:refresh].each {|t|
    sh "sake -u merb:#{t}"
  }
  sh "sake -i http://merbivore.com/merb-dev.sake"
end