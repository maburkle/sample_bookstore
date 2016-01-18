class SearchController < ApplicationController
	def index
		@formats = BookFormatType.all
		@results = Book.search(params[:query], params) || nil
	end
end