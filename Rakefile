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
#    system ("export GOPATH=$HOME/terratest/sql")
#    system ("export PATH=$PATH:/usr/local/go/bin")
    puts `cd terratest/sql`
    puts `go version`
    puts `go get github.com/denisenkom/go-mssqldb`
    puts `go get github.com/gruntwork-io/terratest/modules/retry`
    puts `go get github.com/gruntwork-io/terratest/modules/terraform`
    success = system ("go test")
    if not success 
      raise "ERROR: Go test failed!\n".red
    end
    puts "Hello World!"
  end
  task :hello do
    puts "Hello World!"
  end
end

task :prereqs => []

task :validate => [ 'static:style', 'static:lint', 'static:test']

task :format => [ 'static:format' ]

task :build => [ 'prereqs', 'validate' ]

task :unit => []

task :e2e => []

task :default => [ 'build' ]

task :full => [ 'build', 'unit', 'e2e']
