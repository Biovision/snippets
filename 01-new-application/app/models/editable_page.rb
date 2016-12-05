class EditablePage < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug

  def self.page_for_administration
    ordered_by_name
  end

  def self.entity_parameters
    %i(name title keywords description body)
  end
end
