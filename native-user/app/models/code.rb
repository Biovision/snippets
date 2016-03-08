class Code < ActiveRecord::Base
  include HasOwner

  PER_PAGE = 25

  enum category: [:confirmation, :recovery]

  validates_presence_of :user_id, :body
  validates_uniqueness_of :body

  after_initialize :generate_body

  scope :recent, -> { order 'id desc' }

  def self.page_for_administration(current_page)
    recent.page(current_page).per(PER_PAGE)
  end

  # @param [User] user
  def self.recovery_for_user(user)
    parameters = { user: user, category: categories[:recovery], activated: false }
    self.find_by(parameters) || self.create(parameters.merge(payload: user.email))
  end

  # @param [User] user
  def self.confirmation_for_user(user)
    parameters = { user: user, category: categories[:confirmation], activated: false }
    self.find_by(parameters) || self.create(parameters.merge(payload: user.email))
  end

  # Track IP-address for the recent usage
  #
  # @param [String] ip
  def track!(ip)
    update! ip: ip
  end

  protected

  def generate_body
    if self.body.nil?
      self.body = ''
      Time.now.to_i.to_s(36).reverse.each_char do |char|
        self.body += char + rand(36).to_s(36)
      end
      4.times { self.body += rand(36).to_s(36) }

      self.body = self.body.scan(/.{4}/)[0..3].join('-')
    end
  end
end
