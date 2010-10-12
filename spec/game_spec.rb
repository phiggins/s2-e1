require 'spec_helper'

describe Game do
  it "should be creatable with one argument" do
    Game.new("abc").must_be_kind_of Game
  end

  it "should be creatable with two arguments" do
    Game.new("abc", 6).must_be_kind_of Game
  end

  describe "instances" do
    before do
      @word = "abc"
      @game = Game.new(@word)
    end

    it "should return argument for #word" do
      @game.word.must_equal @word
    end

    it "should return true for a correct #guess" do
      @game.guess('a').must_equal true
    end
    
    it "should return false for a wrong #guess" do
      @game.guess('z').must_equal false
    end

    it "should remember #guesses" do
      @game.guess('a')
      @game.guesses.must_equal ['a']
      @game.guess('z')
      @game.guesses.must_equal ['a','z']
    end

    it "should return true for #won? when all word's letters have been guessed" do
      @game.word.each_char {|l| @game.guess l }
      @game.won?.must_equal true
    end

    it "should return false for #won? when not all of word's letters have been guessed" do
      @game.guess 'a'
      @game.won?.wont_equal true
    end

    it "should return true for #lost? when guess limit exceeded" do
      "zyxwvutsrq".each_char {|c| @game.guess c }
      @game.lost?.must_equal true
    end

    # test depends on Game instance's guess_limit being 5
    it "should return false for #lost? when guess limit not yet exceeded" do
      "zyxwab".each_char {|c| @game.guess c }
      @game.lost?.must_equal false
      @game.guess 'v'
      @game.lost?.must_equal true
    end

    it "should return a hangman-ified version of the string for .to_s" do
      @game.to_s.must_equal "_ _ _"
      @game.guess 'a'
      @game.to_s.must_equal "a _ _"
    end
  end
end
