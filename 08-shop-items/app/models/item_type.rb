class ItemType < ApplicationRecord
  include RequiredUniqueName

  has_many :items, dependent: :destroy

  def self.page_for_administration
    ordered_by_name
  end

  def self.entity_parameters
    %i(name)
  end
end
