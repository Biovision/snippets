require "rails_helper"

RSpec.describe Comments, type: :mailer do
  describe 'entry_reply' do
    
    let!(:entity) { create :comment }
    let(:mail) { Comments.entry_reply(entity) }

    it 'has appropriate subject' do
      expect(mail.subject).to eq(I18n.t('comments.entry_reply.subject'))
    end

    it 'sends from support email' do
      expect(mail.from).to eq(['support@example.com'])
    end

    it 'sends to comment owner' do
      expect(mail.to).to eq([entity.commentable.user.email])
    end

    it 'includes comment in letter body' do
      expect(mail.body.encoded).to match(entity.body)
    end
  end
end
