require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "active_record"
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'flexible_date'))

ActiveRecord::Base.establish_connection(:adapter=>"sqlite3", :database => ":memory:")
require File.join(File.dirname(__FILE__), 'db', 'create_testing_structure')

CreateTestingStructure.migrate(:up)

