module EntriesHelper
  # @param [String] text
  # @param [Integer] passages
  def preview(text, passages = 2)
    text.split("</p>\n<p>")[0...passages].join('</p><p>')
  end

  # @param [String] text
  # @param [Integer] words
  def glimpse(text, words = 100)
    strip_tags(text).gsub(/(\S{20})/, '\1 ').strip.split(/\s+/)[0..words].join(' ') + '…'
  end

  # @param [Entry] entry
  # @param [User] user
  # @param [String] text
  # @param [Hash] options
  def entry_link(entry, user, text = entry.title, options = {})
    if entry.visible_to? user
      link_to (text || t(:untitled)), entry_path({ id: entry.id }.merge(options))
    else
      raw "<span class=\"not-found\">[entry #{entry.id}]</span>"
    end
  end

  # @param [Entry] entry
  def admin_entry_link(entry)
    link_to (entry.title || t(:untitled)), admin_entry_path(entry)
  end
end