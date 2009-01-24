require File.expand_path(File.join(File.dirname(__FILE__), %w[.. .. .. lib archived_attributes]))

describe ArchivedAttributes::Backends::Filesystem do
  before do
    @instance = stub('http_retrieval',
      :uuid => '63d3a120-caca-012b-d468-002332d4f91e'
    )

    aa = ArchivedAttributes::ArchivedAttribute.new(:content, @instance)
    @fs = ArchivedAttributes::Backends::Filesystem.new(aa)
  end

  it "should write to a path under tmp/" do
    @fs.__send__(:file_path).should =~ /tmp/
  end

  it "should save the file to path" do
    @fs.save('test')
  end
  
end
