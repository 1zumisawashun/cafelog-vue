ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

ENV['EXECJS_RUNTIME'] = 'Node'
#bootstrapを導入するために記載した内容です。
