module ArchivedAttributes
  module Backends
    
    class Filesystem

      def initialize(archived_attribute)
        @archived_attribute = archived_attribute
      end

      def save(content)
        FileUtils.mkdir_p(file_path) unless File.exist?(file_path)
        File.open(file_full_name, 'w') { |f| f.write(content) }
      end

      def load
        File.read( file_full_name )
      end

      private

      # Returns the full file path + name of this archived attribute
      def file_full_name
        File.join(file_path, file_name)
      end

      # Returns the file path of this archived attribute, without the file name.
      def file_path
        %W[ #{File.dirname(__FILE__)} .. .. .. tmp archived_attributes
            #{@archived_attribute.instance.uuid} ].join('/')
      end


      # Returns the file name of this archived attribute
      def file_name
        @archived_attribute.name.to_s
      end
    end
    
  end
end