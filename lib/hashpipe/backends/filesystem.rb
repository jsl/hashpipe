module HashPipe
  module Backends
    
    # The filesystem backend is mostly useful for development or test work.  It's not currently sharded
    # in any way, so would probably have serious issues for production use.  You have been warned.
    class Filesystem

      def initialize(archived_attribute)
        @archived_attribute = archived_attribute
      end

      def save(content)
        create_filesystem_path unless File.exist?(filepath)
        write_to_disk(content)
      end

      def destroy
        FileUtils.rm_f(filename)
      end

      def load
        File.read( filename ) if File.exist?( filename )
      end

      # Returns the full file path + name of this archived attribute
      def filename
        File.join(filepath, @archived_attribute.name.to_s)
      end

      private

      # Writes content to disk, or raises an error if the content is unable to
      # be saved
      def write_to_disk(content)
        File.open(filename, 'w') { |f| f.write(content) }
      end

      def create_filesystem_path
        FileUtils.mkdir_p(filepath)
      end

      # The file path used for archiving this attribute.  Includes either the
      # options[:filesystem][:archive_root] attribute, if available, or the
      # RAILS_ROOT/tmp/archived_attribute_archive/attribute_name.
      def filepath
        config_path = @archived_attribute.options[:filesystem][:archive_root]

        base_path =  config_path || File.join(
          %W[#{RAILS_ROOT} tmp hashpipe_stash]
        )

        File.expand_path( File.join(base_path,
            @archived_attribute.name.to_s,
            @archived_attribute.instance.uuid ))
      end

    end
    
  end
end