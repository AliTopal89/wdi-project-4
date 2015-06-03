class User < ActiveRecord::Base
  # attr_accessible :zipcode, :latitude, :longitude

  acts_as_messageable
	has_many :pictures
	has_many :likes

  geocoded_by :zipcode
  after_validation :geocode

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:login]

  
  # constant
  INTEGERS = /\A[0-9]{5}\z/


  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: 3..20
            # format: { with: WORD_CHARS }
  validates :birthday,
            presence: true
  
  validate :over_18


  # has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  # has_many :recipients, through: :sent_messages
  # has_many :received_messages, class_name: 'Message',
  #                              foreign_key: :recipient_id
  # has_many :senders, through: :received_messages

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
  	conditions = warden_conditions.dup
  	if login = conditions.delete(:login)
  		where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  	else
  		if conditions[:username].nil?
  			where(conditions).first
  		else
  			where(username: conditions[:username]).first
  		end
  	end
  end

  def mailboxer_email(object)
    email
  end

   def age
    return 0 if birthday.nil?
    now = Time.now.utc.to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  def over_18
    errors.add(:age, 'must be over 18') if age < 18
   end

end
