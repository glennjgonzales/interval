require 'spec_helper'
require 'intervals'
require 'benchmark'

# @author glennjgonzales <glennjgonzales@gmail.com>
describe Intervals do

  def gen_intervals(min, max, n)
    rnd = Random.new
    xs = []
    n.times do
      _start = rnd.rand(min..max)
      _end = rnd.rand(_start..max)
      xs << [_start, _end]
    end
    xs
  end

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

  it "can merge intervals fast" do
    xs = gen_intervals(0, 1440, 100000)
    expect(xs.size).to eq 100000
    time = Benchmark.measure do
      Intervals.overlaps(xs)
    end
    expect(time.total).to be < 4
  end

  it "can provide a set of non-overlapping intervals given an initial interval" do
    xs = [[480, 540], [600, 675], [660, 750], [780, 870]]
    t = Intervals.make_tree(xs)
  end
end
