class Browser < ActiveRecord::Base
  include RequiredUniqueName

  PER_PAGE   = 20
  TOGGLEABLE = %i(mobile bot active)

  has_many :agents, dependent: :nullify

  # @param [Integer] page
  def self.page_for_administration(page)
    ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(name mobile bot active)
  end

  # @param [String] attribute
  def toggle_parameter(attribute)
    if TOGGLEABLE.include? attribute.to_sym
      toggle! attribute
      { attribute => self[attribute] }
    end
  end
end
