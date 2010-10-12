require 'spec_helper'

describe RequestQueue do
  describe "#parse" do
    before do
      @mail = Mail.new
      @mail.from = "tester_guy@spec.spec"
    end

    it "#parse should filter blank lines and quoted text" do
      @mail.body = [  "\n",             
                      "> You lost! :(",
                      "On Mon, Oct 11, 2010 at 11:26 PM,  <hangman.bot@gmail.com> wrote:"
                    ].join("\n")
      
      parsed = RequestQueue::parse(@mail)
      parsed[:content].must_equal [] 
    end

    it "should filter uppercase text" do
      @mail.body = [  "NEW GAME",
                      "GUESS B"
                    ].join("\n")
      
      parsed = RequestQueue::parse(@mail)
      parsed[:content].must_equal [ "new game", "guess b" ]
    end
  end
end
