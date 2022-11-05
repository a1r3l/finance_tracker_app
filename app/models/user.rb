class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_aready_tracked?(ticker_symbol)
    stock = Stock.check_stock(ticker_symbol)
    return false unless stock
    
    stocks.where(id: stock).exists?
  end
  
  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_aready_tracked?(ticker_symbol)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.search(param)
    param.strip!
    match = ( first_name_matches(param) + 
              last_name_matches(param) + 
              email_matches(param)
            ).uniq
    return nil unless match
    match
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{ param }%")
  end

  def exclude_from_friends(friends_list)
    friends_list.reject { |friend| friend.id == self.id }
  end

  def exclude_existent_friends(friends_list)
    friends_list.select { |friend| !friend.in?(self.friends) }
  end
end
