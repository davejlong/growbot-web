require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

$LOAD_PATH.unshift(::File.expand_path('lib', ::File.dirname(__FILE__)))

require 'growbot/web/env'
Growbot::Web::Env.root = File.expand_path '.', File.dirname(__FILE__)

require 'growbot/web/app'

run Growbot::Web::App
