# == Schema Information
#
# Table name: recordings
#
#  id         :bigint(8)        not null, primary key
#  kind       :string
#  name       :string
#  quality    :integer
#  release_at :datetime
#  sales      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  band_id    :bigint(8)
#  studio_id  :bigint(8)
#
# Indexes
#
#  index_recordings_on_band_id    (band_id)
#  index_recordings_on_studio_id  (studio_id)
#

class Recording < ApplicationRecord
  ## -- RELATIONSHIPS
  belongs_to :band
  belongs_to :studio
  has_many :song_recordings
  has_many :songs, through: :song_recordings
  has_many :single_albums, foreign_key: :album_id
  has_many :singles, through: :single_albums, source: :recording

  ## -- SCOPES
  scope :albums, ->{ where(kind: :album) }
  scope :singles, ->{ where(kind: :single) }
  scope :released, ->{ where.not(release_at: nil) }

  ## — INSTANCE METHODS
  def full_recording
    "#{name} - (#{kind} -- Quality: #{quality})"
  end

end
