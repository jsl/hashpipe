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

      # Returns the file path of this archived attribute, without the file name.
      def filepath
        File.expand_path(%W[ #{File.dirname(__FILE__)} .. .. .. tmp
          archived_attributes #{@archived_attribute.instance.uuid} ].
            join('/'))
      end

    end
    
  end
end