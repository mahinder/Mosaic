class RoomConstraint < ActiveRecord::Base
belongs_to :room
belongs_to :class_timing
belongs_to :weekday
end
