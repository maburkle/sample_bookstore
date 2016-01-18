class BookReview < ActiveRecord::Base
	belongs_to :book

	validates_numericality_of :rating, greater_than: 0, less_than: 6, on: :create
end