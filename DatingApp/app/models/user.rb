class User < ActiveRecord::Base
  # attr_accessible :zipcode, :latitude, :longitude

  acts_as_messageable
	has_many :pictures

  geocoded_by :zipcode
  after_validation :geocode

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable,:omniauth_providers => [:facebook],
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

  # likes me
  has_many :liked_by, class_name: 'Like', as: :likeable, dependent: :destroy
  has_many :likes_me, through: :liked_by, source: :user

  # I like
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :likeable, source_type: 'User'

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
    now = Time.now
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  def over_18
    errors.add(:age, 'must be over 18') if age < 18
   end

   def new_likers_count
    liked_by.where(new: true).count
  end

   def remember_id
    @id = id
  end

  def last_activity
  current_time = Time.now
  "last activity: " +
    if updated_at > current_time - 1.minute
      "now"
    elsif updated_at > current_time - 1.hour
      pluralize(((current_time.to_i - updated_at.to_i) / 60), 'minute') + " ago"
    elsif updated_at > current_time - 1.day
      pluralize(((current_time.to_i - updated_at.to_i) / 3600), 'hour') + " ago"
    else
      pluralize(((current_time.to_i - updated_at.to_i) / 86400), 'day') + " ago"
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.token = auth.credentials.token
      user.expires_at = Time.at(auth.credentials.expires_at)
      # user.create_profile!(name: auth.info.name, photo_url: auth.info.image)
      # user.save!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private

  def pluralize(number, word)
    "#{ number.to_s } #{ word }" + ((number > 1) ? "s" : "")
  end

end
