require 'httparty'
require 'nokogiri'

class Word
  include HTTParty
  base_uri 'http://www.merriam-webster.com/word-of-the-day/'

  def self.word id=random_id
    Nokogiri::HTML( self.get( "/#{id}" ) ).css("strong.main_entry_word").text
  end

  def self.random_id seed=nil
    # m-w.com's word-of-the-day archive starts at Nov 1, 2009
    start = Time.new(2009,11,1)
    # either use what was passed in, or pick a random date between the 
    # beginning of the archive and now
    seed ||= rand( ((Time.now - start) / 86400).floor )

    t = Time.now - (seed*86400)
    t.strftime("%Y/%m/%d")
  end

  def initialize word=nil
    @word = word || self.class.word
  end

  def to_s ; @word ; end
end
