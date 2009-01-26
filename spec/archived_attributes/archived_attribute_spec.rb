require 'rubygems'
require 'activerecord'
require 'mocha'

require File.expand_path(File.join(File.dirname(__FILE__), %w[.. .. lib archived_attributes]))

describe ArchivedAttributes::ArchivedAttribute do
  before do
    options = { 'storage' => :filesystem }
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
end
