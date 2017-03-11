require 'spec_helper'
require 'intervals'


describe Intervals::Tree do

  it "should return the intervals that are repeated a given number of times" do
    t = Intervals.make_tree([[1, 50], [1, 50], [1, 50], [70, 100], [80, 90]])
    repeats = t.repetitions({})
    n = 3
    result = repeats.select { |i, count| count == n }
    expect(result.size).to eq 1
    expect(result.keys).to contain_exactly([1, 50])
  end

end
