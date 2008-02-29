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
  sh "git clone git://github.com/wycats/merb-core.git"
  sh "git clone git://github.com/wycats/merb-more.git"
  sh "git clone git://github.com/wycats/merb-plugins.git"
end

# Usage: sake merb:update
desc "Update your local Merb repositories.  Run from inside the top-level merb directory."
task 'merb:update' do
  repos = %w[core more plugins]
  repos.each do |r|
    p = "merb-#{r}"
    unless File.exists?(p)
      puts "#{p} missing ... did you use merb:clone to set this up?"
      exit
    end
  end
  
  repos.each do |r|
    cd "merb-#{r}"
    sh "git fetch"
    sh "git rebase origin/master"
    cd ".."
  end
end
