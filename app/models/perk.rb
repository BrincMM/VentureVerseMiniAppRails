class Perk < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :category
  belongs_to :sector

  has_many :perk_accesses, dependent: :destroy
  has_many :users, through: :perk_accesses

  validates :partner_name, presence: true
  validates :company_website, presence: true
  validates :contact_email, presence: true
  validates :contact, presence: true

  scope :by_category, ->(category_id) { where(category_id:) if category_id.present? }
  scope :by_sector, ->(sector_id) { where(sector_id:) if sector_id.present? }
  scope :with_any_tags, ->(tags) do
    if tags.present?
      tag_list = tags.map(&:strip)
      joins(:taggings, :tags)
        .where(tags: { name: tag_list })
        .distinct
    end
  end
end
