# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheet::Life, type: :model do
  before(:all) do
    @system = load_system
  end

  it 'serializes the name of the group that holds the life attribute' do
    expect(@system.life.base_attribute_group).to eq('Dados')
  end

  it 'serializes the name of the attribute that representes the character life' do
    expect(@system.life.base_attribute_name).to eq('Vida')
  end
end
