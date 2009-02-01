require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])

describe ArchivedAttributes::GlobalConfiguration do
  before do
    @conf = ArchivedAttributes::GlobalConfiguration.instance
  end

  describe "defaults" do
    it "should set default marshal value to false" do
      ArchivedAttributes::GlobalConfiguration::DEFAULTS[:marshal].should == false
    end
    
    it "should set gzip value to false" do
      ArchivedAttributes::GlobalConfiguration::DEFAULTS[:marshal].should == false
    end
  end

  it "should read default access key from the configuration file" do
    @conf[:s3]['access_key'].should == 'your access key'
  end

  it "should the default secret key from configuration" do
    @conf[:s3]['secret_key'].should == 'your secret key'
  end

  it "should read the default bucket from the configuration file" do
    @conf[:s3]['bucket'].should == 'test_archived_attributes'
  end

  describe "#to_s" do
    it "should return a string" do
      @conf.to_s.should be_an_instance_of(String)
    end
  end

  describe "hash cloning" do
    it "should be able to alter a Hash without affecting the original object" do
      conf = @conf.to_hash
      previous = @conf[:storage]
      conf[:storage] = 'foo'
      @conf[:storage].should == previous
    end

    it "should not affect deeply nested attributes when values are changed" do
      conf = @conf.to_hash
      previous = @conf[:s3][:protocol]
      conf[:s3][:protocol] = 'puddle'
      @conf[:s3][:protocol].should == previous
    end
  end

  describe "#to_hash" do
    it "should return an instance of Hash" do
      @conf.to_hash.should be_an_instance_of(HashWithIndifferentAccess)
    end
  end

  describe "when an option is not specified in the yaml config file" do
    it "should have a section for s3 options in hash" do
      @conf[:s3].should_not be_nil
    end

    it "should default to https for protocol" do
      @conf[:s3][:protocol].should == 'https'
    end

    it "should set default storage attribute to :filesystem" do
      @conf[:storage].should == 'filesystem'
    end
  end

end
