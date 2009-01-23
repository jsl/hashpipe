module ArchivedAttributes
  module Backends
    
    class Filesystem  

      # Saves content and returns unique hash
      def save(content, archived_attribute)
        path = path_from(archived_attribute)
        FileUtils.mkdir_p(path) unless File.exist?(path)

        file = file_from(archived_attribute)
        File.open(File.join(path, file), 'w') { |f| f.write(content) }
      end

      def load(archived_attribute)
        File.read( File.join( path_from(archived_attribute),
            file_from(archived_attribute) ) )
      end

      private

      def path_from(archived_attribute)
        %W[ #{File.dirname(__FILE__)} .. .. .. tmp archived_attributes
            #{archived_attribute.instance.uuid} ].join('/')
      end

      def file_from(archived_attribute)
        archived_attribute.name.to_s
      end
    end
    
  end
end