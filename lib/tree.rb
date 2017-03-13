module Intervals

  # avl tree implementation originally from here:
  #   http://blog.coder.si/2014/02/how-to-implement-avl-tree-in-python.html
  #
  # there's also an avl tree here:
  #   https://github.com/nahi/avl_tree/blob/master/lib/avl_tree.rb
  #
  # @author glennjgonzales <glennjgonzales@gmail.com>
  class Tree

    attr_reader :node, :height, :balance

    def initialize
      @node = nil
      @height = -1
      @balance = 0
    end

    # construct a map of interval to frequency, O(n)
    def frequency_map(acc)
      if @node
        acc[[@node.start, @node.end]] = @node.count
        @node.xs.each do |_start, _end|
          i = [_start, _end]
          acc[i] = acc[i] ? acc[i] + 1 : 1
        end
        @node.left.frequency_map(acc)
        @node.right.frequency_map(acc)
      end

      acc
    end

    # avl insertion, O(log n)
    def insert(_start, _end)
      if not @node
        @node = Node.new(_start, _end)
        @node.left = Tree.new
        @node.right = Tree.new
      elsif @node.start == _start and @node.end == _end
        @node.count += 1
      else
        @node.max_val = [@node.max_val, _end].max
        @node.min_val = [@node.min_val, _start].min
        if _end < @node.start
          @node.left.insert(_start, _end)
        elsif @node.start < _start
          @node.right.insert(_start, _end)
        else
          @node.append(_start, _end)
        end
      end
    end

    # given a point p, return the number of intervals in this tree that contain p, O(n)
    def num_intervals_that_contain(p, acc)
      total = 0

      total += @node.count if @node.start <= p and p <= @node.end
      total += @node.num_intervals_that_contain(p) if @node.min_val <= p and p <= @node.max_val
      if @node.left and @node.left.node and @node.left.node.min_val <= p and p <= @node.left.node.max_val
        total += @node.left.num_intervals_that_contain(p, acc)
      end
      if @node.right and @node.right.node and @node.right.node.min_val <= p and p <= @node.right.node.max_val
        total += @node.right.num_intervals_that_contain(p, acc)
      end

      acc + total
    end

    # avl update height, O(1)
    def update_heights(recursive = true)
      if @node
        if recursive
          @node.left.update_heights if @node.left
          @node.right.update_heights if @node.right
        end
        @height = 1 + [@node.left.height, @node.right.height].max
      else
        @height = -1
      end
    end

    # avl update height, O(1)
    def update_balances(recursive = true)
      if @node
        if recursive
          @node.left.update_balances if @node.left
          @node.right.update_balances if @node.right
        end
        @balance = @node.left.height - @node.right.height
      else
        @balance = 0
      end
    end

    # avl rotation, O(1)
    def rotate_right
      new_root = @node.left.node
      new_left_sub = new_root.right.node
      old_root = @node
      @node = new_root
      old_root.left.node = new_left_sub
      new_root.right.node = old_root
      new_root.min_val = old_root.min_val
      new_root.max_val = old_root.max_val
      if new_left_sub
        old_root.min_val = [old_root.min_val, new_left_sub.min_val].min
        old_root.max_val = [old_root.max_val, new_left_sub.max_val].max
      end
    end

    # avl rotation, O(1)
    def rotate_left
      new_root = @node.right.node
      new_right_sub = new_root.left.node
      old_root = @node
      @node = new_root
      old_root.right.node = new_right_sub
      new_root.left.node = old_root
      new_root.min_val = old_root.min_val
      new_root.max_val = old_root.max_val
      if new_right_sub
        old_root.min_val = [old_root.min_val, new_right_sub.min_val].min
        old_root.max_val = [old_root.max_val, new_right_sub.max_val].max
      end
    end

    # avl rebalance, O(1)
    def rebalance
      update_heights(recursive = false)
      update_balances(recursive = false)

      while @balance < -1 or @balance > 1
        if @balance > 1
          if @node.left.balance < 0
            @node.left.rotate_left
            update_heights
            update_balances
          end
          rotate_right
          update_heights
          update_balances
        end

        if @balance < -1
          if @node.right.balance > 0
            @node.right.rotate_right
            update_heights
            update_balances
          end
          rotate_left
          update_heights
          update_balances
        end
      end
    end
  end
end
