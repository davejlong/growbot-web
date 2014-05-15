require 'ashikawa-core'
module Growbot
  module Web
    class Data
      attr_accessor :database

      def initialize
      end

      def get
        dataset = []
        query = <<-QUERY
          FOR row in readings
            FILTER row.moisture != 0
            FILTER row.light != 0
            FILTER row.time >= #{start_time}
            FILTER row.time <= #{end_time}
            SORT row.time ASC
            RETURN row
        QUERY
        collection.query.execute(query).each do |document|
          dataset << document.to_h
        end
        dataset
      end

      private
      def start_time
        (Time.now - 6*24*60*60).to_i * 1000
      end

      def end_time
        (Time.now - 4*24*60*60).to_i * 1000
      end

      def database
        @database ||= Ashikawa::Core::Database.new do |config|
          config.url = 'http://localhost:8529/_db/growbot'
        end
      end

      def collection
        @collection ||= database[:readings]
      end
    end
  end
end
