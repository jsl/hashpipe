require File.join(File.dirname(__FILE__), %w[ .. .. spec_helper ])

describe HashPipe::Backends::Memcache do

  before do
    @instance = stub('ar_instance', 
      :uuid => '63d3a120-caca-012b-d468-002332d4f91e',
      :table_name => 'glorps'
    )
    
    @aa = HashPipe::ArchivedAttribute.new(:stuff, @instance)
    @mc = HashPipe::Backends::Memcache.new(@aa)
    @mc.stubs(:key_name).returns('foo-key')

    @mock_store = mock('memcache_store')
    @mc.stubs(:cache).returns(@mock_store)
  end

  describe "#initialize" do
    it "should initialize a memcached object without error" do
      lambda { HashPipe::Backends::Memcache.new(@aa) }.should_not raise_error
    end
  end

  describe "#load" do
    it "should call method to load data from memcached" do
      @mock_store.expects(:get)
      @mc.load
    end
  end

  describe "#save" do
    it "should call method to store data in memcached" do
      @mock_store.expects(:write)
      @mc.save('content')
    end
  end

  describe "#destroy" do
    it "should call method to delete key" do
      @mock_store.expects(:delete)
      @mc.destroy
    end
  end
end
