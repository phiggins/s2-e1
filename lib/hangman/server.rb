module Hangman
  class Server
    def self.start queue=nil
      new(queue).start
    end

    def initialize queue, wait=nil
      @queue = queue || Request
      @wait = wait || 30
    end

    def start
      loop do
        while request = @queue.next
          puts "processing request:\n#{request.inspect}"
          request.process
        end
        puts "sleeping for #{@wait} seconds."
        sleep @wait
      end
    end
  end
end
