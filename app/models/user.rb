class User
  include DataMapper::Resource

  property :id,               Serial
  property :count,            Integer
  property :email, String, required: true, format: :email_address, unique: true
  property :password_digest,  Text
  property :name, String, required: true
  property :username, String, required: true, unique: true

  # property :password_token, Text
  # property :password_token_time, Time

  attr_reader :password
  attr_accessor :password_confirmation

  validates_presence_of :email
  validates_confirmation_of :password


  def password=(password)
  	@password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end
end