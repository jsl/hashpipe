require File.join(File.dirname(__FILE__), %w[ .. .. spec_helper ])

describe ArchivedAttributes::Backends::S3 do

  before do
    @instance = stub('ar_instance', 
      :uuid => '63d3a120-caca-012b-d468-002332d4f91e',
      :table_name => 'glorps'
    )
    
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
      config = { :protocol => 'http' }
      @s3.instance_variable_set(:"@config", config)
      
      @s3.__send__(:protocol).should == "http"
    end

  end

  describe "#load" do
    it "should call method to load data from s3" do
      bucket = mock('bucket')
      bucket.expects(:get).once
      aws_s3 = mock('aws_s3')
      aws_s3.expects(:bucket).returns(bucket)
      @s3.expects(:key_name).returns('some-key')
      @s3.expects(:right_aws_s3).returns(aws_s3)
      @s3.load
    end
  end

  describe "#save" do
    it "should call method to store data in s3" do
      bucket = mock('bucket')
      content = 'hey'
      key = 'fookey'
      @s3.expects(:key_name).returns(key)
      bucket.expects(:put).once
      aws_s3 = mock('aws_s3')
      aws_s3.expects(:bucket).returns(bucket)
      @s3.expects(:right_aws_s3).returns(aws_s3)
      @s3.save(content)
    end
  end

  describe "#destroy" do
    it "should call method to delete key" do
      key = mock('key', :delete => true)
      bucket = mock('bucket', :key => key)
      aws_s3 = mock('aws_s3')
      aws_s3.expects(:bucket).returns(bucket)
      @s3.expects(:right_aws_s3).returns(aws_s3)
      @s3.expects(:key_name).returns('foo-key')
      @s3.destroy
    end
  end

  describe "#bucket_name" do
    it "should be based on the attribute class and model" do
      @s3.__send__(:bucket_name).should == @config[:s3]['bucket']
    end
  end
end
