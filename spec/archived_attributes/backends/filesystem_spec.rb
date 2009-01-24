require File.expand_path(File.join(File.dirname(__FILE__),
    %w[.. .. .. lib archived_attributes]))

describe ArchivedAttributes::Backends::Filesystem do

  before do
    @instance = stub('http_retrieval',
      :uuid => '63d3a120-caca-012b-d468-002332d4f91e'
    )

    @content = 'some test content'
    aa = ArchivedAttributes::ArchivedAttribute.new(@content, @instance)
    @fs = ArchivedAttributes::Backends::Filesystem.new(aa)
  end

  it "should write to the correct path" do
    path_start = File.expand_path(File.join(File.dirname(__FILE__),
        %W[.. .. .. tmp archived_attributes #{@instance.uuid }]))
    @fs.__send__(:filepath).should == path_start
  end

  describe "#save" do
    it "should call methods to create path and save file to disk" do
      @fs.expects(:write_to_disk).returns(true)
      @fs.expects(:create_filesystem_path).returns(true)
      @fs.save('test')
    end
  end

end
