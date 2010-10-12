Mail.defaults do
  retriever_method :pop3, { 
    :address             => "pop.gmail.com",
    :port                => 995,
    :user_name           => Hangman::Creds::Name,
    :password            => Hangman::Creds::Password,
    :enable_ssl          => true }
  
  delivery_method :smtp, {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "gmail",
    :user_name            => Hangman::Creds::Name,
    :password             => Hangman::Creds::Password,
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
end
