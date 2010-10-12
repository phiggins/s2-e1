module Hangman
  class Server
    def self.start opts={}
      new(opts).start
    end

    def initialize opts 
      @queue    = opts[:queue] || Request
      @wait     = opts[:wait] || 30
      @verbose  = opts[:verbose]
    end

    def start
      loop do
        while request = @queue.next
          puts "processing request:\n#{request.inspect}" if @verbose
          request.process
        end
        puts "sleeping for #{@wait} seconds." if @verbose
        sleep @wait
      end
    end
  end
end
