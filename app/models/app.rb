class App < ApplicationRecord
  acts_as_taggable_on :tags

  has_many :app_activities, dependent: :destroy
  has_many :app_accesses, dependent: :destroy
  has_many :users, through: :app_accesses

  validates :app_name, presence: true, uniqueness: true
  validates :link, url: true, allow_blank: true

  # Scopes
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_sector, ->(sector) { where(sector: sector) if sector.present? }
  scope :with_any_tags, ->(tags) do
    if tags.present?
      tag_list = tags.map { |tag| tag.strip }
      joins(:taggings, :tags)
        .where(tags: { name: tag_list })
        .distinct
    end
  end
  scope :with_all_tags, ->(tags) { tagged_with(tags, all: true) if tags.present? }
  scope :accessible_by_user, ->(user_id) { joins(:app_accesses).where(app_accesses: { user_id: user_id }) }

  def grant_access_to(user)
    app_accesses.create!(user: user)
  end

  def revoke_access_from(user)
    app_accesses.find_by(user: user)&.destroy
  end

  def accessible_by?(user)
    app_accesses.exists?(user: user)
  end
end 