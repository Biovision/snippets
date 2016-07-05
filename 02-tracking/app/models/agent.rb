class Agent < ActiveRecord::Base
  include RequiredUniqueName

  PER_PAGE   = 20
  TOGGLEABLE = %i(mobile bot active)

  belongs_to :browser, counter_cache: true

  # @param [Integer] page
  def self.page_for_administration(page)
    ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(browser_id name mobile bot active)
  end

  # Get instance of Agent for given string
  #
  # Trims agent name upto 255 characters
  #
  # @param [String] name
  # @return [Agent]
  def self.named(name)
    criterion = { name: name[0..254] }
    self.find_by(criterion) || self.create(criterion)
  end

  # @param [String] attribute
  def toggle_parameter(attribute)
    if TOGGLEABLE.include? attribute.to_sym
      toggle! attribute
      { attribute => self[attribute] }
    end
  end
end