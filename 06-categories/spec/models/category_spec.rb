require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build :category }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_name'

  describe 'validation' do
    it 'fails with non-unique name for parent' do
      create :category, parent_id: subject.parent_id, name: subject.name
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'fails without priority' do
      subject.priority = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:priority)
    end
  end

  describe '#cache_parents!' do
    context 'when category has no parent' do
      before :each do
        subject.parent_id = nil
        subject.cache_parents!
      end

      it 'sets cache to empty string' do
        expect(subject.parents_cache).to eq('')
      end
    end

    context 'when category has parents chain' do
      let!(:top_category) { create :category }
      let!(:parent_category) { create :category, parent: top_category }

      before :each do
        parent_category.cache_parents!
        subject.parent = parent_category
        subject.cache_parents!
      end

      it 'sets cache to list of parent ids' do
        expected = ",#{top_category.id},#{parent_category.id}"
        expect(subject.parents_cache).to eq(expected)
      end
    end
  end

  describe '#cache_children!' do
    before(:each) { subject.save! }

    context 'when category has no children' do
      before :each do
        subject.cache_children!
      end

      it 'sets cache to empty array' do
        expect(subject.children_cache).to eq([])
      end
    end

    context 'when category has children' do
      let!(:first_child) { create :category, parent: subject }
      let!(:second_child) { create :category, parent: first_child }
      let!(:third_child) { create :category, parent: first_child }

      before :each do
        first_child.cache_children!
        subject.cache_children!
      end

      it 'sets cache to array with children ids' do
        expected = [first_child.id, second_child.id, third_child.id]
        expect(subject.children_cache).to eq(expected)
      end
    end
  end

  describe 'before save' do
    before :each do
      subject.children_cache = [100, 100, 101, 101, 101, 102, 100, 102, 101]
    end

    it 'makes children cache unique' do
      subject.save!
      expect(subject.children_cache).to eq([100, 101, 102])
    end
  end
end
