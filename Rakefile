require "bundler/gem_tasks"

desc 'Start Interactive Couchbase'
task :console do
  bindir = File.join(File.dirname(__FILE__), "bin")
  exec "ruby -Ilib -ricouchbase #{bindir}/icouchbase"
end
