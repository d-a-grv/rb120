class CircularQueue
  attr_reader :queue

  def initialize(size)
    @queue = [nil] * size
    @el_order = []
    @oldest_el = nil
  end

  def enqueue(el)
    unless queue.any?(&:nil?)
      dequeue
    end
    queue[empty_idx] = el
    el_order << el
  end

  def dequeue
    self.oldest_el = el_order.shift
    queue[oldest_idx] = nil
    oldest_el
  end

  def empty_idx
    queue.index(nil)
  end

  def oldest_idx
    queue.index(oldest_el)
  end

  private

  attr_accessor :el_order, :oldest_el
end

queue = CircularQueue.new(3)
puts queue.dequeue.nil?
queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue.nil?

queue = CircularQueue.new(4)
puts queue.dequeue.nil?

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue.nil?
