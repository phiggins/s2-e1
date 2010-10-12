module Hangman
  class Server
    def self.start opts={}
      new(opts).start
    end

    def initialize opts 
      @queue    = opts[:queue] || RequestQueue.new
      @wait     = opts[:wait] || 30
      @verbose  = opts[:verbose]
    end

    def start
      loop do
        @queue.process!
        sleep @wait
      end
    end
  end
end
