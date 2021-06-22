class Author < ActiveRecord::Base
    has_many :publications
end