require 'spec_helper'

describe Word do
  it ".random_id should return correct query fragment for m-w.com scraping" do
    today = Time.now.strftime("%Y/%m/%d")
    Word.random_id(0).must_equal today
  end

  it ".word should return a word scraped from m-w.com" do
    Word.word("2010/09/25").must_equal "flippant"
  end
end
