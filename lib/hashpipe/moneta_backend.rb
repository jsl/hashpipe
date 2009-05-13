module HashPipe
  class MonetaBackend
    
    def initialize(archived_attribute)
      @archived_attribute = archived_attribute
      @options            = HashPipe::GlobalConfiguration.instance[:moneta_options]
      @cache              = initialize_cache_klass(HashPipe::GlobalConfiguration.instance[:moneta_klass])
    end

    def save(content)
      @cache[key_name] = content
    end

    def destroy
      @cache.delete(key_name)
    end

    def load
      @cache[key_name]
    end

    private

    def initialize_cache_klass(cache_klass)
      require_moneta_library_for(cache_klass)
      klass_const = cache_klass.respond_to?(:constantize) ? cache_klass.constantize : cache_klass      
      klass_const.new(@options)
    end
    
    def require_moneta_library_for(cache_klass)
      require cache_klass.to_s.gsub(/::/, '/').downcase
    end

    def key_name
      [ table_name_from(@archived_attribute),
        @archived_attribute.name,
        @archived_attribute.instance.uuid ].join('/')
    end
    
    def table_name_from(archived_attribute)
      archived_attribute.instance.class.table_name
    end
  end
end