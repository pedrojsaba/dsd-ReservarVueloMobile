class Seat < ActiveRecord::Base
	has_many :flights
end
