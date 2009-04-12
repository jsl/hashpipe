module HashPipe

  # Singleton class for reading the defaults archived attribute configuration
  # for this environment.
  class GlobalConfiguration
    include Singleton

    DEFAULTS = HashWithIndifferentAccess.new({
      :storage    => 'filesystem',
      :marshal    => false,
      :compress   => false,
      :s3 => {
        :protocol => 'https'
      },
      :filesystem => {
        :archive_root => nil
      }
    })
    
    def [](val)
      config[val]
    end

    def to_hash
      config
    end

    def to_s
      config.inspect
    end

    private

    def config
      @config ||= HashWithIndifferentAccess.new(
        DEFAULTS.merge(load_yaml_configuration)
      )

      @config.dup
    end

    def load_yaml_configuration
      YAML.load_file(
        File.join( RAILS_ROOT, 'config', 'hashpipe.yml' )
      )[RAILS_ENV]
    end
  end

end