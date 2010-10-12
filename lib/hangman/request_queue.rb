module Hangman
  class RequestQueue
    def next
      request = Mail.find(:count => 1)

      # Mail.find(:count=>1) returns either:
      # - an empty array if there are no messages, or
      # - a Mail::Request or somesuch
      unless request.respond_to?(:empty?) and request.empty?
        Request.new( RequestQueue::parse(request) )
      end 
    end

    def self.parse request
      content = if request.multipart?
        request.parts.first.body.to_s
      else
        request.body.to_s
      end

      content = content.downcase.split("\n").reject do |line|
        case line
          when /^\s*>/          ; true    # quoted line
          when /hangman.?bot/   ; true    # top of quoted lines
          when /^\s*$/          ; true    # blank line
          else                  ; false
        end
      end

      { :email    => request.from,
        :content  => content }
    end

    def process!
      while request = self.next
        begin
          request.process
        rescue Exception => e
          $stderr.puts [ "Exception processing request:", request.inspect,
            "#{e} (#{e.class})", e.backtrace].join("\n")
          raise
        end
      end
    end
  end
end
