# frozen_string_literal: true

require Rails.root.join('lib', 'devise', 'encryptors', 'md5')

class User < ApplicationRecord
  extend FriendlyId

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  friendly_id :name, use: :slugged

  has_many :characters, dependent: :delete_all
  has_many :subscriptions, dependent: :delete_all

  validates :name, :slug, presence: true

  def valid_password?(password)
    return false if encrypted_password.blank?

    if legacy_password.present?
      md5 = Devise::Encryptable::Encryptors::Md5.digest(password, nil, nil, nil)

      if Devise.secure_compare(md5.chomp, legacy_password.chomp)
        new_password = User.new(:password => password).encrypted_password
        self.update(legacy_password: nil, encrypted_password: new_password)
      else
        false
      end
    else
      super(password)
    end
  end

  def self.permitted_parameters
    [:name]
  end
end
