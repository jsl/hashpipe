require File.join(File.dirname(__FILE__), %w[ .. spec_helper ])

describe ArchivedAttributes::GlobalConfiguration do
  before do
    @conf = ArchivedAttributes::GlobalConfiguration.instance
  end

  it "should read default access key from the configuration file" do
    puts @conf[:s3]
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

  describe "#to_hash" do
    it "should return an instance of Hash" do
      @conf.to_hash.should be_an_instance_of(Hash)
    end
  end

  describe "when an option is not specified in the yaml config file" do
    it "should have a section for s3 options in hash" do
      @conf[:s3].should_not be_nil
    end

    it "should default to https for protocol" do
      @conf[:s3]['protocol'].should == 'https'
    end

    it "should set default_storage to :filesystem" do
      @conf[:storage].should == 's3'
    end
  end

end
