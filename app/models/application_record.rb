class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include AbstractController::Translation
end
