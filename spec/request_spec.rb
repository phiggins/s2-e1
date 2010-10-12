require 'spec_helper'

describe Request do
  before do
    Mail.defaults { delivery_method :test }
  end

  after do
    Mail::TestMailer.deliveries.clear
  end

  describe "when asked to create a game" do
    before do
      @email = next_email
      @req = Request.new(:email => @email, :content => "new game")
      @req.process
    end

    it "should create a game for the asker" do
      user = User.find_or_create(@email)
      user.game.must_be_kind_of Game
    end

    it "should reply to the asker" do
      m = Mail::TestMailer.deliveries.first
      m.to.must_equal [@email]
      m.body.to_s.must_match /Created a new game/i
    end
  end

  describe "when a guess is made" do
    before do
      @email = next_email
      @user = User.find_or_create(@email)
      @user.game = Game.new "ab"
    end

    it "should tell the guesser when they were correct" do
      req = Request.new(:email => @email, :content => "guess a")
      req.process

      m = Mail::TestMailer.deliveries.first
      m.to.must_equal [@email]
      m.body.to_s.must_match /\scorrect/i
    end

    it "should tell the guesser when they were wrong" do
      req = Request.new(:email => @email, :content => "guess z")
      req.process

      m = Mail::TestMailer.deliveries.first
      m.to.must_equal [@email]
      m.body.to_s.must_match /\sincorrect/i
    end

    it "should tell the guesser when they have won" do
      req = Request.new :email    => @email, 
                        :content  => "guess a\nguess b"
      req.process

      m = Mail::TestMailer.deliveries.first
      m.to.must_equal [@email]
      m.body.to_s.must_match /you won/i
    end

    it "should tell the guesser when they have lost" do
      guesses = %w(z y x w v).map {|c| "guess #{c}" }.join("\n")

      req = Request.new :email    => @email, 
                        :content  => guesses
      req.process

      m = Mail::TestMailer.deliveries.first
      m.to.must_equal [@email]
      m.body.to_s.must_match /you lost/i
    end

    it "should filter blank lines and quoted text" do
      content = [ "\n",             
                  "> You lost! :(",
                  "On Mon, Oct 11, 2010 at 11:26 PM,  <hangman.bot@gmail.com> wrote:"
                ].join("\n")
      
      req = Request.new :email    => @email, 
                        :content  => content
      req.process

      m = Mail::TestMailer.deliveries.first
      m.to.must_equal [@email]
      m.body.to_s.wont_match /I didn't understand/i
    end

    it "should be case insensitive" do
      content = [ "NEW GAME",
                  "GUESS B"
                ].join("\n")
      
      req = Request.new :email    => @email, 
                        :content  => content
      req.process

      m = Mail::TestMailer.deliveries.first
      m.to.must_equal [@email]
      m.body.to_s.wont_match /I didn't understand/i
    end

    it "should not respond to guesses when the game is over" do
      user = User.find_or_create(next_email)
      game = Game.new("ab")
      user.game = game
      
      content = "guess a\nguess b\nguess c"
      
      req = Request.new :email    => @email, 
                        :content  => content
      req.process

      m = Mail::TestMailer.deliveries.first
      m.to.must_equal [@email]
      m.body.to_s.wont_match /You won.*You won/im
    end
  end
end
