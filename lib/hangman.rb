require 'mail'

begin
  require 'hangman/creds'
rescue LoadError
  message = <<-OMGBROKEN
It looks like you haven't setup Hangman yet.
Put a file in lib/hangman called creds.rb that looks like this:

module Hangman
  module Creds
    Name      = <gmail username>
    Password  = <gmail password>
  end
end

... then you should be good to go!
OMGBROKEN

  $stderr.puts message
  exit 1
end

%w( mail_setup game server request user word ).each do |lib|
  require "hangman/#{lib}"
end

module Hangman
  VERSION = "0.0.1"

  def self.start
    Server.start
  end
end
