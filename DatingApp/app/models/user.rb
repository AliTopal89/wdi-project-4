class User < ActiveRecord::Base
  acts_as_messageable
	has_many :pictures
	has_many :likes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:login]


  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: 3..20
            # format: { with: WORD_CHARS }

  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  has_many :recipients, through: :sent_messages
  has_many :received_messages, class_name: 'Message',
                               foreign_key: :recipient_id
  has_many :senders, through: :received_messages

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

end
