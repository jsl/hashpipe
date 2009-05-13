require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])

describe HashPipe::ArchivedAttribute do
  before do
    stub_model = stub(:uuid => '43')
    @aa = HashPipe::ArchivedAttribute.new(:glorp, stub_model)
    HashPipe::MonetaBackend.any_instance.stubs(:table_name_from).returns('foo_table')
  end

  describe "#dirty?" do
    it "should return false when a value has not been set" do
      @aa.should_not be_dirty
    end

    it "should return when the value has been set" do
      @aa.value = 'stuff'
      @aa.should be_dirty
    end
    
    it "should not be dirty after save is called" do
      @aa.value = 'stuff'
      @aa.should be_dirty
      @aa.save
      @aa.should_not be_dirty      
    end
  end

  describe "#marshal?" do
    it "should return false if configuration option is nil" do
      @aa.expects(:options).returns({:marshal => nil})
      @aa.__send__(:marshal?).should be_false
    end

    it "should return value from configuration if configuration option is not nil" do
      @aa.expects(:options).returns({:marshal => false}).times(2)
      @aa.__send__(:marshal?).should be_false
    end
  end

  describe "#compress?" do
    it "should return false if configuration option is nil" do
      @aa.expects(:options).returns({:compress => nil})
      @aa.__send__(:compress?).should be_false
    end

    it "should return value from configuration if configuration option is not nil" do
      @aa.expects(:options).returns({:compress => false}).times(2)
      @aa.__send__(:compress?).should be_false
    end
  end

  describe "#destroy" do
    it "should call destroy on the backend object" do
      backend = mock('backend', :destroy => true)
      @aa.instance_variable_set(:'@backend', backend)
      @aa.destroy
    end
  end

  describe "when marshal is on" do
    before do
      @content = 'mary had a little lamb'
      stub_backend = stub('backend', :load => Marshal.dump(@content))
      @aa.stubs(:options).
        returns({ :storage => 'filesystem', :marshal => true })
      @aa.__send__(:instance_variable_set, :'@backend', stub_backend)
    end

    it "should call Marshal.load to restore value" do
      Marshal.expects(:load)
      @aa.value
    end

    it "should call Marshal.dump to save value" do
      Marshal.expects(:dump)
      @aa.value = 'foo'
    end

    it "should retrieve same content string stored in Marshalled form" do
      @aa.value.should == @content
    end
  end

  describe "when gzip is on" do
    before do
      @content = "The band formed in 1988 in Oxford"
      stub_backend = stub('backend', :load => Zlib::Deflate.deflate(@content))
      @aa.stubs(:options).
        returns({ :storage => 'filesystem', :compress => true })
      @aa.__send__(:instance_variable_set, :'@backend', stub_backend)
    end

    it "should call Zlib::Inflate.inflate to restore value" do
      Zlib::Inflate.expects(:inflate)
      @aa.value
    end

    it "should call Zlib::Deflate.deflate to save value" do
      Zlib::Deflate.expects(:deflate)
      @aa.value = 'foo'
    end

    it "should retrieve same content string stored in gzip form" do
      @aa.value.should == @content
    end

    it "should not raise an error with nil content" do
      lambda {
        @aa.value = nil
      }.should_not raise_error
    end
  end

  describe "when compress and marshal are on" do
    before do
      @content = "The band formed in 1988 in Oxford"
      stub_backend = stub('backend', :load => Zlib::Deflate.deflate(Marshal.dump(@content)))
      @aa.stubs(:options).
        returns({ :storage => 'filesystem', :compress => true, :marshal => true })
      @aa.__send__(:instance_variable_set, :'@backend', stub_backend)
    end

    it "should retrieve the same content given" do
      @aa.value.should == @content
    end
  end
end
