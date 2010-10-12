require 'minitest/spec'
require 'minitest/mock'
MiniTest::Unit.autorun

require 'hangman'
include Hangman

def next_email
  @@emails ||= 0
  @@emails += 1
  "test_email_#{@@emails}@email.com"
end
