class User
  attr_accessor :game
  attr_reader :email

  def self.find_or_create email
    @users ||= {}
    user = @users[email]
    if user
      user.visit!
      return user
    end
    @users[email] = new(email)
  end

  def initialize email
    @email = email
    @visits = 0
  end

  def visit!
    @visits += 1
  end

  def noob?
    @visits == 0
  end
end
