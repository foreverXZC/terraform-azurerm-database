# Official gems.
require 'colorize'
require 'rspec/core/rake_task'

# Git repo gems.
require 'bundler/setup'
require 'terramodtest'

namespace :static do
  task :style do
    style_tf
  end
  task :lint do
    lint_tf
  end
  task :format do
    format_tf
  end
  task :test do
    system ("export GOPATH=$HOME/terratest")
    system("export PATH=$PATH:/usr/local/go/bin")
    system("go get github.com/denisenkom/go-mssqldb")
    system("go get github.com/gruntwork-io/terratest/modules/retry")
    system("go get github.com/gruntwork-io/terratest/modules/terraform")
    system("cd terratest/sql")
    system("go test")
    puts "Hello World!"
  end
  task :hello do
    puts "Hello World!"
  end
end

task :prereqs => []

task :validate => [ 'static:style', 'static:lint', 'static:hello', 'static:test']

task :format => [ 'static:format' ]

task :build => [ 'prereqs', 'validate' ]

task :unit => []

task :e2e => []

task :default => [ 'build' ]

task :full => [ 'build', 'unit', 'e2e']
