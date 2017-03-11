require 'spec_helper'
require 'intervals'
require 'benchmark'

# @author glennjgonzales <glennjgonzales@gmail.com>
describe Intervals::Tree do

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

  it "should return the intervals that are repeated a given number of times" do
    t = Intervals.make_tree([[1, 50], [1, 50], [1, 50], [70, 100], [80, 90]])
    repeats = t.repetitions({})
    n = 3
    result = repeats.select { |i, count| count == n }
    expect(result.size).to eq 1
    expect(result.keys).to contain_exactly([1, 50])

    t = Intervals.make_tree([[1, 10], [1, 10], [1, 10], [1, 10], [1, 10]])
    repeats = t.repetitions({})
    result = repeats.select { |i, count| count == 5 }
    expect(result.keys).to contain_exactly([1, 10])
  end

  it "should return the interval frequency map fast" do
    xs = gen_intervals(0, 1440, 100000)
    expect(xs.size).to eq 100000
    f_map = {}
    time = Benchmark.measure do
      t = Intervals.make_tree(xs)
      f_map = t.repetitions({})
    end

    expect(f_map.values.reduce(:+)).to eq 100000
    expect(time.total).to be < 4
  end

end
