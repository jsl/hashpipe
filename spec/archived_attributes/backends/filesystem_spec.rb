require File.join(File.dirname(__FILE__), %w[ .. .. spec_helper ])

require 'tmpdir'

describe ArchivedAttributes::Backends::Filesystem do

  before do
    @unique_path_part = 'archived_attributes_test'
    @path = File.join(Dir.tmpdir, @unique_path_part)
    
    
    @instance = stub('http_retrieval',
      :uuid => '63d3a120-caca-012b-d468-002332d4f91e',
      :name => :foo
    )

    aa = ArchivedAttributes::ArchivedAttribute.new(:content, @instance,
      :filesystem => { :archive_root => @path } )
    
    @fs = ArchivedAttributes::Backends::Filesystem.new(aa)
  end

  it "should write to the correct path" do
    @fs.__send__(:filepath).should ==
      File.expand_path(File.join(@path, 'content', @instance.uuid))
  end

  describe "#save" do    
    before do
      if File.exist?(@path)
        err = <<-EOS
          Test directory #{@path} already exists.  Please remove it and run the
          test suite again.
        EOS
        raise RuntimeError, err
      else
        @remove_path = true
        FileUtils.mkdir(@path)
      end
    end

    it "should call methods to create path and save file to disk" do
      @fs.save('test')
      File.exist?(@fs.filename).should be_true
    end
    
    after(:all) do
      FileUtils.rm_rf(@path) if @remove_path
    end
    
  end

  describe "#destroy" do
    before do
      if File.exist?(@path)
        err = <<-EOS
          Test directory #{@path} already exists.  Please remove it and run the
          test suite again.
        EOS
        raise RuntimeError, err
      else
        @remove_path = true
        FileUtils.mkdir(@path)
      end
    end

    it "should call methods to remove path and file" do
      @fs.save('test')
      File.exist?(@fs.filename).should be_true

      @fs.destroy
      File.exist?(@fs.filename).should be_false
    end

    after(:all) do
      FileUtils.rm_rf(@path) if @remove_path
    end

  end


end
