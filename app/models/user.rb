# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  validates :kind, inclusion: { in: %w(1 2), message: "must be '1' or '2'" }, if: -> { kind.present? }

  
  has_many :dog_profiles

  has_many :dog_walking_jobs
end
