require 'rubygems'
require 'bundler/setup'
require 'vcr'
require 'mongoid'

require_relative '../lib/bitbot'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end
