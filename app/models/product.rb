class Product < ActiveRecord::Base
	default_scope :order => 'title'
  has_many :line_items
  before_destroy :ensure_not_refereneced_by_any_line_item
  attr_accessible :description, :image_url, :price, :title
  validates :title, :description, :image_url, :price, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :length => { :minimum => 10 }
  validates :title, :uniqueness => true
  validates :image_url, :format => {
    :with   => %r{\.(gif|jpg|png)$}i,
    :message => 'Broke ass, make this a URL for a GIF, JPG, or PNG.'
  }
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end
end
