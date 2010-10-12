module Hangman
  class Game
    attr_reader :word, :guesses, :guess_limit

    def initialize word=nil, guess_limit=5
      @word = word || Word.new
      @guesses = []
      @guess_limit = guess_limit
    end

    def guess letter
      @guesses << letter
      @word.to_s.include?(letter)
    end

    def won?
      @word.to_s.chars.all? {|c| @guesses.include?(c) }
    end

    def lost?
      bad_guesses.size >= @guess_limit
    end

    def bad_guesses
      @guesses.reject {|c| @word.to_s.include?(c) }
    end

    def to_s
      @word.to_s.each_char.map do |char|
        @guesses.include?(char) ? char : "_"
      end.join(" ")
    end
  end
end
