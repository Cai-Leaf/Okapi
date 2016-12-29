class Api < ApplicationRecord
    
    validates :name, presence: true
    validates :version, presence: true
    validates :path, presence: true
    
end
