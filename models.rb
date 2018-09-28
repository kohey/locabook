require 'bundler/setup'
Bundler.require

if development?
    ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
    has_secure_password
    has_many :ownerships
    has_many :books, through: :ownerships
    
    validates :name, presence: true
    validates :email, presence: true,
                      format: {with:/.+@.+/}
                      
    validates :password,length: {in: 5..10}
end

class Ownership < ActiveRecord::Base
    belongs_to :user
    belongs_to :book
end

class Item < ActiveRecord::Base
    has_many :ownerships
    has_many :users, through: :ownerships
    
    validates :code, presence: true, length: { maximum: 255 }
    validates :name, presence: true, length: { maximum: 255 }
    validates :url, presence: true, length: { maximum: 255 }
    validates :image_url, presence: true, length: { maximum: 255 }
end