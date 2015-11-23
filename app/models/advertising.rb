class Advertising
  include Mongoid::Document
  extend Refile::Mongoid::Attachment

  field :name,        type: String
  field :description, type: String
  field :address,     type: String
  field :price,       type: Float
  #field :user_ud,     type: Integer

  belongs_to :user

  attachment :image_preview, type: :image

  field :location, type: Array
  index(
    { location: '2d' }, { min: -200, max: 200 }
  )

  validates :name, :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 10, less_than_or_equal_to: 1000}

  validate :check_location


  def as_json()
    json = {
      "type": "Ad",
      "id": id.to_s,
      "geometry": {
        "type": "Point",
        "coordinates": [location[0], location[1]]
      },
      "properties": {
        "name": name,
        "description": description.truncate(120),
        "price": price,
        "image_url": Refile.attachment_url(self, :image_preview, :fill, 32, 32, format: "jpg"),
        "hintContent": name
      }
    }
  end

  def self.json_for_yandex_map(collection)
    {
      "type": "FeatureCollection",
      "features": collection.as_json
    }.to_json
  end

  private

  def check_location
    if location.blank?
      self.errors.add(:address, "У данного адреса не определяются координаты")
      false
    else
      true
    end
  end

end