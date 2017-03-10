require 'spec_helper'
require 'intervals'


describe Intervals do

  it "should accept a sequence of intervals to create a tree" do
    t = Intervals.make_tree([[1, 4], [5, 10], [8, 16]])
    expect(t).not_to be_nil
    expect(t.node).not_to be_nil
    expect(t.node.left).not_to be_nil
    expect(t.node.right).not_to be_nil
    expect(t.node.min_val).to eq 1
    expect(t.node.max_val).to eq 16
  end
end
