# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Area, type: :model do
  describe '#profile?' do
    it 'is in profile area' do
      expect(Area.new(:profile)).to be_profile
    end

    it 'is not in profile area' do
      expect(Area.new).to_not be_profile
    end
  end

  describe '#panel?' do
    it 'is in the admin panel' do
      expect(Area.new(:panel)).to be_panel
    end

    it 'is in not the admin panel' do
      expect(Area.new).to_not be_panel
    end
  end

  describe '#edit_post?' do
    it 'is editing a post' do
      expect(Area.new(:edit_post)).to be_edit_post
    end

    it 'is not editing a post' do
      expect(Area.new).to_not be_edit_post
    end
  end

  describe '#current' do
    it 'shows the current area' do
      expect(Area.new(:home).current).to eq(:home)
    end
  end
end
