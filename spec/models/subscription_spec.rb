# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :user }
  it { should belong_to :game }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :game_id }
  it { should validate_presence_of :status }
end
