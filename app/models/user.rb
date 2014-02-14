class User < ActiveRecord::Base
	has_many :roomies
	has_many :rooms, through: :roomie
	has_many :photos
	has_secure_password
end
