class Room < ActiveRecord::Base

	reverse_geocoded_by :latitude, :longitude
	#after_validation :reverse_geocod

	has_many :roomies
	has_many :users, through: :roomie
	has_many :photos
end
