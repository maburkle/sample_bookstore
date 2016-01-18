class Book < ActiveRecord::Base
	belongs_to :author
	belongs_to :publisher
	has_many :book_reviews
	has_many :reviews
	has_many :book_formats
	has_many :book_format_types, through: :book_formats

	scope :physical_available, -> { joins(:book_formats).where(["book_formats.book_format_type_id IN (?)", BookFormatType.where(physical: true).map{|x| x.id}]) }

	def author_name
		"#{self.author.full_name}"
	end

	def average_rating
		reviews = self.book_reviews
		total_rating = 0
		reviews.each do |review|
			total_rating += review.rating
		end
		return (total_rating.to_f/reviews.count).round(1)
	end

	def self.search(query, options = {})
		unless query.blank?
			query = query.downcase
			title_only = options[:title_only] || nil
			format = options[:format_type]
			available_physical = options[:physical] || nil

			if available_physical
				if title_only == "1"
					results = self.physical_available.where("lower(title) like ?", "%#{query}%")
				else
					results = self.physical_available.includes(:author, :publisher).where("lower(books.title) like ? OR lower(authors.first_name) like ? OR lower(authors.last_name) like ? OR lower(publishers.name) like ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%").references(:author)
				end
			else
				if title_only == "1"
					results = self.where("lower(title) like ?", "%#{query}%")
				else
					results = self.includes(:author, :publisher).where("lower(books.title) like ? OR lower(authors.first_name) like ? OR lower(authors.last_name) like ? OR lower(publishers.name) like ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%").references(:author)
				end
			end

			results = results.joins(:book_formats).where(["book_formats.book_format_type_id=?", format]) if format != ""

			results.uniq

		end
	end
end
