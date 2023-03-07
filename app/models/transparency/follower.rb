class Transparency::Follower < ApplicationDataRecord

  # Associations

  belongs_to :resourceable, polymorphic: true


  # Validations

  ## Presence
  validates :email,
    :resourceable,
    :transparency_link,
    presence: true

  ## Format
  # @SPRC
  # validates_format_of :email, with: User::REGEX_EMAIL_FORMAT

  ## Uniqueness
  validates_uniqueness_of :email,
    scope: [:resourceable_id, :resourceable_type, :unsubscribed_at]

end
