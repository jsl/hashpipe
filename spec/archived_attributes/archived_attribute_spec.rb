require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])

describe ArchivedAttributes::ArchivedAttribute do
  before do
    options = { :storage => 'filesystem' }
    @aa = ArchivedAttributes::ArchivedAttribute.new(Object, Object.new, options)
  end

  describe "#dirty?" do
    it "should return false when a value has not been set" do
      @aa.should_not be_dirty
    end

    it "should return when the value has been set" do
      @aa.value = 'stuff'
      @aa.should be_dirty
    end
  end

  describe "#destroy" do
    it "should call destroy on the backend object" do
      backend = mock('backend', :destroy => true)
      @aa.instance_variable_set(:'@backend', backend)
      @aa.destroy
    end
  end

  describe "when options include :marshal" do
    before do
      options = { :storage => 'filesystem', :marshal => true }
      stub_model = stub(:uuid => '43')
      @aa = ArchivedAttributes::ArchivedAttribute.new(Object, stub_model, options)
    end

    it "should call Marshal.load to restore value" do
      Marshal.expects(:load)
      @aa.value
    end

    it "should call Marshal.dump to save value" do
      Marshal.expects(:dump)
      @aa.value = 'foo'
    end
  end
end
