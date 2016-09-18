require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { build :category }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_name'

  describe 'after initialize' do
    it 'sets next priority' do
      subject.save!
      entity = Category.new(parent_id: subject.parent_id)
      expect(entity.priority).to eq(subject.priority + 1)
    end
  end

  describe 'before validation' do
    it 'generates slug as transliterated name' do
      subject.name = '  Категория в тестах!  '
      subject.valid?
      expect(subject.slug).to eq("kategoriya-v-testakh")
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

  describe 'validation' do
    it 'fails with non-unique name for same parent' do
      create :category, parent_id: subject.parent_id, name: subject.name
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'passes with non-unique name for other parent' do
      create :category, name: subject.name, slug: 'another_category', parent: subject
      expect(subject).to be_valid
    end

    it 'fails without priority' do
      subject.priority = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:priority)
    end

    it 'fails with non-unique slug' do
      subject.valid?
      create :category, slug: subject.slug
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
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

  describe '#parents' do
    context 'when parents present' do
      let!(:top_category) { create :category }
      let!(:parent_category) { create :category, parent: top_category }

      before :each do
        parent_category.cache_parents!
        subject.parent = parent_category
        subject.cache_parents!
      end

      it 'returns list of parents' do
        expect(subject.parents).to eq([top_category, parent_category])
      end
    end

    context 'when no parents present' do
      it 'returns empty array' do
        expect(subject.parents).to eq([])
      end
    end
  end
end
