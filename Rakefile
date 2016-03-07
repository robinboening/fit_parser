# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require './lib/fit_parser/version'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "fit_parser"
  gem.version = FitParser::VERSION
  gem.homepage = "http://github.com/zhublik/fit_parser"
  gem.license = "MIT"
  gem.summary = ""
  gem.description = ""
  gem.email = "dima.mescheryakov@gmail.com"
  gem.authors = ["Dima Mescheryakov"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
