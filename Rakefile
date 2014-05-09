require "bundler/gem_tasks"
require 'coffee-script'

namespace :assets do
  namespace :js do
    desc "Compile CoffeeScripts into public directory"
    task :compile do
      source = File.join File.dirname(__FILE__), 'lib', 'growbot', 'web', 'views', 'coffee', '*.coffee'
      dest = File.join File.dirname(__FILE__), 'public', 'javascripts'
      Dir.mkdir dest unless Dir.exist? dest

      Dir[source].each do |file|
        script = CoffeeScript.compile File.read(file)
        File.open File.join(dest, File.basename(file).gsub('.coffee', '.js')), 'w' do |f|
          f.puts script
        end
      end
    end
  end

  namespace :css do
    desc "Compile SASS into public directory"
    task :compile do
      source = File.join File.dirname(__FILE__), 'lib', 'growbot', 'web', 'views', 'sass', '*.scss'
      dest = File.join File.dirname(__FILE__), 'public', 'stylesheets'

      Dir.mkdir dest unless Dir.exist? dest

      Dir[source].each do |file|
        spawn "sass #{file}:#{File.join(dest, File.basename(file).gsub('.scss', '.css'))} --style compressed"
      end
    end
  end

  desc "Compile all static assets (CSS and JS) from source"
  task :compile => ['js:compile', 'css:compile']
end
