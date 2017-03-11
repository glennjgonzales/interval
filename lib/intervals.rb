
module Intervals

  # search for _start in the (ordered) sequence of pairs xs, O(log n)
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

  # Construct an avl tree out of the given sequence of pairs (intervals), O(nlog n)
  def self.make_tree(ys)
    t = Tree.new
    ys.each do |y|
      _start, _end = y[0], y[1]
      t.insert(_start, _end)
    end
    t
  end

  # Subtract interval y from x as sets: A - B = all x in A that are not in B, O(1)
  def self.subtract(x, y)
    x1, x2 = x[0], x[1]
    y1, y2 = y[0], y[1]
    if y2 < x1 or y1 > x2
      [x]
    else
      d = []
      d << [x1, y1] if y1 - x1 > 0
      d << [y2, x2] if x2 - y2 > 0
      d
    end
  end

  # greedy algorithm for merging the intervals, O(nlog n) because of sorting
  def self.overlaps(xs)
    xs.sort! { |x, y| x[0] <=> y[0] }
    r = []
    xs.each do |_start, _end|
      last_start, last_end = r.last ? [r.last[0], r.last[1]] : [Float::INFINITY, -Float::INFINITY]
      if _start > last_end
        r << [_start, _end]
      else
        r.pop
        r << [last_start, [_end, last_end].max]
      end
    end
    r
  end

end

require 'tree'
require 'node'
