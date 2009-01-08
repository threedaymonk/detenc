require 'rake/testtask'
require 'rake/clean'

CLOBBER.include('bin/*', 'src/usage.h')

task :default => :build

desc 'Build the detenc binary.'
task :build => 'bin/detenc'

desc 'Install the detenc binary to /usr/local/bin.'
task :install => :build do |t|
  cp 'bin/detenc', '/usr/local/bin'
end

file 'bin' do |t|
  mkdir_p t.name
end

file 'bin/detenc' => FileList['src/*.[ch]'] + ['src/usage.h'] + ['bin'] do |t|
  sources = t.prerequisites.select{ |n| n =~ /\.c$/ }
  sh "cc -Wall -o #{t.name} #{sources * ' '}"
end

file 'src/usage.h' => 'src/usage.txt' do |t|
  usage = File.read(t.prerequisites.first).gsub(/\n/, "\\\\n")
  File.open(t.name, 'w') do |io|
    io.puts(%{#define USAGE_TEXT "#{usage}"})
  end
end

desc 'Test the compiled binary.'
Rake::TestTask.new(:test => :build) do |t|
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end
