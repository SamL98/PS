require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  test "should not save without identifier" do
  	subj = Subject.new({condition: 1})
  	assert_not subj.save  	
  end

  test "should not save without condition" do
  	subj = Subject.new({identifier: "subj01"})
  	assert_not subj.save
  end
end
