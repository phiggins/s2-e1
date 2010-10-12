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

          # Running the server in rake would swallow exceptions. I can make 
          # sure I get verbose output this way.
          begin
            request.process
          rescue Exception => e
            $stderr.puts ["#{e} (#{e.class})", e.backtrace].join("\n")
            raise
          end
        end
        puts "sleeping for #{@wait} seconds." if @verbose
        sleep @wait
      end
    end
  end
end
