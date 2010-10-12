require 'rake/testtask'
Rake::TestTask.new("spec") do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList['spec/*_spec.rb']
end

desc "start game server"
task :start do
  $LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")
  require "hangman"
  puts "starting server"
  Hangman.start
end
