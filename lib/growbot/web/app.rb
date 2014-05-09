require 'sinatra/base'
require 'sinatra/json'
require 'yajl'

require_relative '../web'
require_relative 'data'

module Growbot
  module Web
    class App < Sinatra::Base
      configure do
        set :root, File.expand_path(File.dirname(__FILE__))

        set :public_folder, File.join(settings.root, '..', '..', '..', 'public')

        set :haml, format: :html5, layout: :layout
        set :scss, views: File.join(settings.root, 'views/sass')
        if ENV['RACK_ENV'].eql? 'production'
          set :scss, style: :compressed,
            cache: true,
            cache_location: '/tmp/growbot-sass-cache'
        else
          set :scss, style: :expanded
        end

        set :coffee, views: File.join(settings.root, 'views/coffee'),
          cache: true,
          cache_location: '/tmp/growbot-coffee-cache'

      end

      get '/' do
        haml :index
      end

      get '/data.json' do
        json Data.new.get
      end

      get '/stylesheets/:sheet.css' do
        scss params[:sheet].to_sym
      end

      get '/javascripts/:script.js' do
        coffee params[:script].to_sym
      end
    end
  end
end
