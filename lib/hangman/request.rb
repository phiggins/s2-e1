module Hangman
  class Request
    def initialize opts={}
      @from = opts[:email]
      @user = User.find_or_create(@from)
      @content = opts[:content]
    end

    def process
      @responses = @content.map do |command|
        case command
        when /^new/
          new_game
        when /^guess/
          letter = command.split(" ").last
          guess letter
        else
          "I didn't understand: \"#{command}\""
        end
      end

      send_reply
    end

    def new_game
      game = Game.new
      @user.game = game
      "Created a new game:\n#{game.to_s}"
    end
    
    def guess letter
      game = @user.game
      return "" if game.won? or game.lost?

      correct = game.guess letter
      message = ["You guessed: #{letter}"]

      if game.won? || game.lost?
        message << "You won!" if game.won?
        message << "You lost! :(" if game.lost?
        message << "Your word was: \"#{game.word}\""
        message << "Tell me \"new game\" to start again."
      else
        message << "That's #{"in" unless correct}correct!"
        message << "#{game.to_s}"
        message << "You've guessed: #{game.guesses.join(", ")}"
      end

      message.join("\n")
    end

    SPACER = "="

    def send_reply
      mail          = Mail.new
      mail.from     = "hangmanbot@gmail.com"
      mail.subject  = "Reply from hangmanbot"
      mail.to       = @from
      mail.body     = @responses.join("\n\n#{SPACER * 10}\n\n")

      mail.deliver!
    end
  end
end
