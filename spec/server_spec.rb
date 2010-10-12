require 'spec_helper'
require 'timeout'

describe Server do
  it "should sleep if no pending Requests" do
    queue = MiniTest::Mock.new
    queue.expect :next, nil

    Thread.abort_on_exception = true
    t = Thread.new { Server.start :queue => queue }
    sleep 0.1
    t.kill

    queue.verify
  end

  # XXX: MiniTest::Mock doesn't support different return values for successive
  # calls, so I can't make the queue return a valid request and then nil. 
  # This led to my array hacks below...
  it "should process next Request if one is pending" do
    request = MiniTest::Mock.new
    request.expect :process, :true
    
    queue = [request]
    queue.instance_eval { alias :next :shift }

    Thread.abort_on_exception = true
    t = Thread.new { Server.start :queue => queue }
    sleep 0.1
    t.kill

    request.verify
    queue.must_equal []
  end
end
