module Intervals

  # a node in a tree.
  #
  # avl tree implementation originally from here:
  #   http://blog.coder.si/2014/02/how-to-implement-avl-tree-in-python.html
  #
  # there's also an avl tree here:
  #   https://github.com/nahi/avl_tree/blob/master/lib/avl_tree.rb
  #
  # @author glennjgonzales <glennjgonzales@gmail.com>
  class Node
    attr_reader :start, :end, :xs
    attr_accessor :count, :size
    attr_accessor :min_val, :max_val
    attr_accessor :left, :right

    def initialize(_start, _end)
      @start, @end = _start, _end
      @min_val, @max_val = _start, _end
      @count = 1
      @size = 1
      @left = nil
      @right = nil
      @xs = []
    end

    def append(_start, _end)
      if @xs.empty?
        xs[0] = [_start, _end]
      else
        idx = binary_search(@xs, _start)
        if idx != -1
        elsif _start <= @xs[0][0]
          @xs = [[_start, _end]] + @xs
        else
          @xs << [_start, _end]
        end
      end
    end

    # given a point p, return the number of intervals in this node that contain p
    def num_intervals_that_contain(p)
      if p == @start
        @xs.length
      else
        result, idx, size = 0, 0, @xs.length
        while idx < size and @xs[idx][0] <= p and p <= @xs[idx][1]
          result += 1
          idx += 1
        end
        result
      end
    end
  end
end
