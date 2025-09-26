class Perk < ApplicationRecord
  acts_as_taggable_on :tags

  has_many :perk_accesses, dependent: :destroy
  has_many :users, through: :perk_accesses

  validates :partner_name, presence: true
  validates :company_website, presence: true
  validates :contact_email, presence: true
  validates :contact, presence: true

  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_sector, ->(sector) { where(sector: sector) if sector.present? }
  scope :with_any_tags, ->(tags) do
    if tags.present?
      tag_list = tags.map(&:strip)
      joins(:taggings, :tags)
        .where(tags: { name: tag_list })
        .distinct
    end
  end
end
