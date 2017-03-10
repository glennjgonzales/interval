
module Intervals

  def self.binary_search(xs, _start)
    left, right = 0, xs.length - 1
    while right - left >= 0
      idx = left + ((right - left) / 2.0).ceil
      if (xs[idx][0] == _start) or (idx - 1 >= 0 and xs[idx - 1][0] < _start and _start < xs[idx][0])
        return idx
      elsif idx + 1 < xs.length and xs[idx][0] < _start and _start < xs[idx + 1][0]
        return idx + 1
      elsif _start < xs[idx][0]
        right = idx - 1
      else
        left = idx + 1
      end
    end
    -1
  end

  def self.make_tree(ys)
    t = Tree.new
    ys.each do |y|
      _start, _end = y[0], y[1]
      t.insert(_start, _end)
    end
    t
  end

end

require 'tree'
require 'node'
