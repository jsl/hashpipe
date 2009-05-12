module HashPipe
  module Backends

    class Memcache

      def initialize(archived_attribute)
        @archived_attribute = archived_attribute
        @config = HashPipe::GlobalConfiguration.instance[:memcache]
      end

      def save(content)
        cache.write( key_name, content ) unless content.nil?
      end

      def destroy
        cache.delete(key_name)
      end

      def load
        cache.read(key_name)
      end

      private

      def cache
        @cache ||= ActiveSupport::Cache::MemCacheStore.new(server)
      end

      def key_name
        [ @archived_attribute.instance.class.table_name,
          @archived_attribute.name,
          @archived_attribute.instance.uuid ].join('/')
      end

      def server
        "#{@config[:server]}:#{@config[:port]}" 
      end
      
    end

  end
end