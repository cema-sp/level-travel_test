require 'typhoeus'

# Make Typhoeus use Rails cache
Typhoeus::Config.cache = RailsCacheDelegator.new(Rails.cache)
