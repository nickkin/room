class User
  include Mongoid::Document

  authenticates_with_sorcery!
  field :email, type: String
  field :crypted_password, type: String
  field :salt, type: String

  has_many :ads

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  validates :email, uniqueness: true, email: true
end
