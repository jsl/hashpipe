require File.expand_path(File.join(File.dirname(__FILE__),
    %w[.. .. .. lib archived_attributes]))

describe ArchivedAttributes::Backends::S3 do

  # Test instance
  class Glorp
    def uuid
      '63d3a120-caca-012b-d468-002332d4f91e'
    end
  end

  before do
    @instance = Glorp.new
    
    @aa = ArchivedAttributes::ArchivedAttribute.new(:stuff, @instance)
    @s3 = ArchivedAttributes::Backends::S3.new(@aa)
    @config = ArchivedAttributes::GlobalConfiguration.instance
  end

  describe "#initialize" do
    it "should initialize an s3 object without error" do
      lambda { ArchivedAttributes::Backends::S3.new(@aa) }.should_not raise_error
    end
  end

  describe "#protocol" do
    it "should be https by default" do
      @s3.__send__(:protocol).should == "https"
    end

    it "should use http if specified in the configuration object" do
      config = { 'protocol' => 'http' }
      @s3.instance_variable_set(:"@config", config)
      
      @s3.__send__(:protocol).should == "http"
    end

  end

  describe "#load" do
    it "should call method to load data from s3"
  end

  describe "#save" do
    it "should have some tests"
  end

  describe "#bucket_name" do
    it "should be based on the attribute class and model" do
      @s3.__send__(:bucket_name).should == @config['s3']['bucket']
    end
  end
end
