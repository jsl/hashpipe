require File.join(File.dirname(__FILE__),  'spec_helper')

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile => ":memory:"
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Base.silence do
  ActiveRecord::Schema.define do
    create_table :stories do |table|
      table.string :uuid
      table.string :title
      table.string :content_key
      table.string :description_key
    end
  end
end

ActiveRecord::Base.__send__(:include, HashPipe)

class Story < ActiveRecord::Base
  hattr :content
  hattr :description, { :marshalled => true }
end

describe HashPipe do
  before do
    @lamb_text    =  'Baaah!'
    @bear_struct  =  OpenStruct.new(:blah => 'arg')
    @lamb_story   =  Story.create!(:title => 'lamb story', :content => @lamb_text)
    @bear_story   =  Story.create!(:title => 'bear story', :content => 'Raaaar!', :description => @bear_struct)
  end

  it "should retrieve textual content" do
    @lamb_story.content.should == @lamb_text
  end

  it "should load marshalled objects" do
    @bear_story.description.should == @bear_struct
  end

  it "shouldn't change uuid after it is initially set" do
    lambda {
      @bear_story.save!
    }.should_not change(@bear_story, :uuid)
  end

  [:save_archived_attributes, :destroy_archived_attributes].each do |sym|
    it "should respond to attached storage method #{sym}" do
      Story.new.should respond_to(sym)
    end
  end

  describe "#destroy_archived_attributes" do
    it "should be called on destruction of object" do
      @bear_story.expects(:destroy_archived_attributes).at_least_once
      @bear_story.destroy
    end
  end
end
