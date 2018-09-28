AtiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")

class Item < ActiveRecord::Base
    has_many :ownerships
    has_many :users, through: :ownerships
end

class User < ActiveRecord::Base
    has_many :ownerships
    has_many :items, through: :ownerships
end

class Ownership < ActiveRecord::Base
    belongs_to :item
    belongs_to :user
end
