module ArchivedAttributes

  # Singleton class for reading the defaults archived attribute configuration
  # for this environment.
  class GlobalConfiguration
    include Singleton

    DEFAULTS = {
      'default_storage' => :filesystem,
      's3' => {
        'protocol' => 'https'
      }
    }
    
    def [](val)
      config[val]
    end

    def to_s
      config.inspect
    end

    def to_hash
      config
    end

    private

    def config
      @config ||= load_yaml_configuration.reverse_merge(DEFAULTS)
    end

    def load_yaml_configuration
      YAML.load_file(
        File.join( RAILS_ROOT, 'config', 'archived_attributes.yml' )
      )[RAILS_ENV]
    end
  end

end