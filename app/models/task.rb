class Task < ApplicationRecord
	# def self.task_list
	# 	return Task.all
	# end
	belongs_to :user
end
