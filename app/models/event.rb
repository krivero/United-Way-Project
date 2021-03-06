class Event < ApplicationRecord
  validates :title, :description, :start_at, :end_at, :location, :street_address, :city, :state, :zip, :image, presence: true
  belongs_to :user, optional: true
  has_many :rsvps
  has_one_attached :image

  scope :ordered, -> { order(:start_at) }
  scope :between, ->(start_date, end_date) do
    where(
      "start_at >= ? and end_at <= ?",
      start_date.beginning_of_day.to_datetime,
      end_date.end_of_day.to_datetime
    )
  end

  def image_url
    return rails_blob_path(self.image) if self.image.attachment
  end

  scope :future, -> { where("start_at >= ?", Time.now )}

end
