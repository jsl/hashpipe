module ArchivedAttributes
  module Backends
    
    class Filesystem

      def initialize(archived_attribute)
        @archived_attribute = archived_attribute
      end

      def save(content)
        create_filesystem_path unless File.exist?(filepath)
        write_to_disk(content)
      end

      def destroy
        FileUtils.rm(filename)
      end

      def load
        File.read( filename )
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
      # options[:path] attribute, if available, or the RAILS_ROOT path + tmp.
      # Also includes the name of the attribute for namespacing.
      def filepath
        base_path = @archived_attribute.options[:path] ||
          File.join(RAILS_ROOT, 'tmp')

        File.expand_path( File.join(base_path,
            @archived_attribute.name.to_s,
            @archived_attribute.instance.uuid ))
      end

    end
    
  end
end