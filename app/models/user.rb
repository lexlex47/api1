class User < ApplicationRecord
    validates :login, presence: true, uniqueness: { case_sensitive: true }
    validates :provider, presence: true

    has_one :access_token, dependent: :destroy
end
