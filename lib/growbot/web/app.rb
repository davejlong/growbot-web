require 'sinatra/base'
require 'sinatra/json'
require 'yajl'

require_relative '../web'
require_relative 'env'
require_relative 'data'

module Growbot
  module Web
    class App < Sinatra::Base
      configure do
        set :root, Growbot::Web::Env.root

        set :public_folder, File.join(Growbot::Web::Env.root, 'public')
        set :haml, format: :html5, layout: :layout
        set :scss, style: :expanded, views: 'views/sass'
        set :coffee, views: 'views/coffee'
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
