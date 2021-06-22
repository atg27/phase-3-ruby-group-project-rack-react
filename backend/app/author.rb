class Author < ActiveRecord::Base
    has_many :publications

    def number_of_publications
        self.publications.count
    end

end