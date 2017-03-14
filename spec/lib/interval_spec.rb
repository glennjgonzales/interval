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
    size = 100000
    xs = gen_intervals(0, 1440, size) # 00:00 to 23:59 in minutes
    expect(xs.size).to eq size
    time = Benchmark.measure do
      Intervals.overlaps(xs)
    end
    expect(time.total).to be < 4
  end

  it "can provide a set of non-overlapping intervals given an initial interval" do
    # first elem is the 'given' interval, rest of list is the set of intervals to include
    xs = [[480, 540], [600, 675], [660, 750], [780, 870]]
    t = Intervals.make_tree_no_conflict(xs)
    r = Intervals.overlaps(t.to_ary)
    expect(r).to contain_exactly([600, 675], [480, 540], [780, 870])

    # here the 'given' element is [660, 750]
    xs = [[660, 750], [480, 540], [600, 675], [780, 870]]
    t = Intervals.make_tree_no_conflict(xs)
    r = Intervals.overlaps(t.to_ary)
    expect(r).to contain_exactly([660, 750], [480, 540], [780, 870])
  end

  it "can find a non-overlapping set of intervals fast" do
    size = 1000000 # 1 million
    xs = gen_intervals(0, 1440, size)
    head = xs[0]
    t = nil
    time = Benchmark.measure do
      t = Intervals.make_tree_no_conflict(xs)
    end
    puts "\nnoconflicts done in #{'%.2f' % time.total}s"
    expect(time.total).to be < 4
    ary = t.to_ary
    r = Intervals.overlaps(ary)
    expect(r.size).to eq ary.size
    expect(r).to match_array ary
    # puts "found non-conflicting intervals: #{r}" if r.size < 20
    # puts "starting interval was #{head}" if r.size < 20
  end

  it "can find a non-overlapping set of intervals for each interval in the set fast" do
    size = 1000
    xs = gen_intervals(0, 1440, size)
    t = nil
    non_overlap = []
    time = Benchmark.measure do
      for i in 0..(size-1)
        t = Intervals.make_tree_no_conflict(xs)
        non_overlap << t.to_ary
        h = xs.shift
        xs += [h]
      end
    end
    puts "\nallnoconflicts done in #{'%.2f' % time.total}s"
    expect(time.total).to be < 4
    expect(non_overlap.size).to eq size
    non_overlap.each do |rs|
      ms = Intervals.overlaps(rs)
      expect(ms).to match_array rs
    end
  end
end
