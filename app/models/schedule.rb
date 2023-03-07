class Schedule < ApplicationDataRecord

  # Regex constant
  REGEX_CRON_SYNTAX = /\A(\*|([0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])|\*\/([0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])) (\*|([0-9]|1[0-9]|2[0-3])|\*\/([0-9]|1[0-9]|2[0-3])) (\*|([1-9]|1[0-9]|2[0-9]|3[0-1])|\*\/([1-9]|1[0-9]|2[0-9]|3[0-1])) (\*|([1-9]|1[0-2])|\*\/([1-9]|1[0-2])) (\*|([0-6])|\*\/([0-6]))\z/

  # Callbacks
  after_save :send_cron_later, if: :cron_syntax_frequency_changed?

  # Validations
  validates_format_of :cron_syntax_frequency, with: REGEX_CRON_SYNTAX, allow_blank: true

  # Associations
  belongs_to :scheduleable, polymorphic: true


  # Privates

  private

  ## Callbacks

  def send_cron_later
    delay.update_cron
  end

  def update_cron
    system "whenever --update-crontab sprc_#{ENV['STAGE']}"
  end

end
