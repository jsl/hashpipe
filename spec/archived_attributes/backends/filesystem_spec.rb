require File.join(File.dirname(__FILE__), %w[ .. .. spec_helper ])

describe ArchivedAttributes::Backends::Filesystem do

  before do
    @instance = stub('http_retrieval',
      :uuid => '63d3a120-caca-012b-d468-002332d4f91e'
    )

    @path = '/tmp/archived_attributes'
    aa = ArchivedAttributes::ArchivedAttribute.new(@content, @instance,
      :path => @path)
    
    @fs = ArchivedAttributes::Backends::Filesystem.new(aa)
  end

  it "should clean up filesystem after tests are run"

  it "should write to the correct path" do
    @fs.__send__(:filepath).should ==
      File.expand_path(File.join(@path, @instance.uuid))
  end

  describe "#save" do
    it "should call methods to create path and save file to disk" do
      @fs.expects(:write_to_disk).returns(true)
      @fs.expects(:create_filesystem_path).returns(true)
      @fs.save('test')
    end
  end

end
