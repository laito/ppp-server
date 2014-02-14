class Photo < ActiveRecord::Base
	belongs_to :user
	belongs_to :room
  	has_attached_file :photo,
                    :styles => { :medium => "300x300>", :thumbnail => "100x100>" }

end
