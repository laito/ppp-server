class User < ActiveRecord::Base
	has_many :roomies
	has_many :rooms
	has_many :photos
	has_secure_password
end
