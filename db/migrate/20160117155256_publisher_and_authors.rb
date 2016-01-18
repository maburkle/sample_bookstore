class PublisherAndAuthors < ActiveRecord::Migration
  def change
  	create_table :publishers do |t|
    	t.string :name
    	t.timestamps
    end

    create_table :authors do |t|
    	t.string :first_name
    	t.string :last_name
    	t.timestamps
    end

    create_table :book_format_types do |t|
    	t.string :name
    	t.boolean :physical
    	t.timestamps
    end

    create_table :book_formats do |t|
    	t.integer :book_id
    	t.integer :book_format_type_id
    	t.timestamps
    end

    create_table :book_reviews do |t|
    	t.integer :book_id
    	t.integer :rating
    	t.timestamps
    end
  end
end
