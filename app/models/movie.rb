class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end
  def self.with_ratings(ratings_list)
    if ratings_list.nil? || ratings_list.empty?
      # If no ratings are provided, return all movies
      all
    else
      # Use the where clause to filter movies by ratings
      where(rating: ratings_list)
    end
  end
end
