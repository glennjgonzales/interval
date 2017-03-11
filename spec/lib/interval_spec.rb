require 'spec_helper'
require 'intervals'

# @author glennjgonzales <glennjgonzales@gmail.com>
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

  it "subtracts an interval from another based on set subtraction" do
    r = Intervals.subtract([1, 100], [1, 50])
    expect(r).to eq [[50, 100]]
  end

  it "can merge overlapping intervals into a new set of intervals" do
    xs = [[1,4], [2,5], [6,8], [8, 12], [9, 11]]
    result = Intervals.overlaps(xs)
    expect(result.size).to eq 2
    expect(result).to contain_exactly([1, 5], [6, 12])
  end
end
