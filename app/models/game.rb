# frozen_string_literal: true

class Game < ApplicationRecord
  extend FriendlyId

  has_many :topic_groups, -> { order(:position) }
  has_many :characters
  has_many :subscriptions

  belongs_to :character

  friendly_id :name, use: :slugged

  validates :name, length: { maximum: 45 }
  validates :short_description, length: { maximum: 320 }
  validates :name, :slug, presence: true

  scope :active, -> { where(status: :active) }

  enum status: [:inactive, :active]

  before_create :ensure_owner_is_game_master
  after_create :set_game_to_owner

  def system
    @system ||= Sheet::System.new(raw_system)
  end

  def close!
    inactive!
    subscriptions.each(&:destroy)
  end

  def reopen!
    active!
  end

  def pcs
    find_by_type(0)
  end

  def npcs
    find_by_type(1)
  end

  def masters
    find_by_type(2)
  end

  private

  def find_by_type(type)
    characters
      .where('characters.character_type = ?', type)
      .order('characters.name')
  end

  def ensure_owner_is_game_master
    character.game_master!
  end

  def set_game_to_owner
    character.update(game: self)
  end
end
