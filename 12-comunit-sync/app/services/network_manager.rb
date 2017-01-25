class NetworkManager

  # @param [Site] site
  # @param [Hash] attributes
  # @param [Hash] data
  def update_site(site, attributes, data = {})
    site.assign_attributes(attributes)
    site.save!
  end

  private

  def request_headers
    {
        content_type: :json,
        signature:    Rails.application.secrets.signature_token
    }
  end
end