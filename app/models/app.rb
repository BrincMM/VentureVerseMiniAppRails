class App < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :category
  belongs_to :sector
  belongs_to :developer, optional: true

  has_many :app_activities, dependent: :destroy
  has_many :app_accesses, dependent: :destroy
  has_many :users, through: :app_accesses
  has_many :api_keys, dependent: :destroy

  # Rails 8 enum syntax
  enum :status, { active: 0, disabled: 1, reviewing: 2, dev: 3 }

  validates :name, presence: true
  validates :name, uniqueness: { conditions: -> { where.not(status: :disabled) } }
  validates :app_url, url: true, allow_blank: true

  # Set default status to dev for new records
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :dev
  end

  public

  # Scopes
  scope :published, -> { where(status: [:active, :reviewing]) }
  scope :by_category, ->(category_id) { where(category_id:) if category_id.present? }
  scope :by_sector, ->(sector_id) { where(sector_id:) if sector_id.present? }
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