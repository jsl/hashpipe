smodule ArchivedAttributes
  module Backends
    
    class Filesystem      
      def initialize(path)
        @path = path
        FileUtils.mkdir_p(path) unless File.exist?(path)
      end

      # Saves content and returns unique hash
      def save(content)
        File.open(File.join(@path, 'foo.txt'), 'w') {|f| f.write(content) }
        MD5.hexdigest(content + DateTime.now.to_s)
      end

      def load
        puts "loading data in #{@path}/foo.txt"
        File.read(File.join(@path, 'foo.txt'))
      end
    end
    
  end
end