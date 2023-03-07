class Integration::Contracts::Convenants::CreateStats < Integration::Contracts::Contracts::CreateStats

  attr_accessor :year, :month

  def self.call(year, month)
    new(year, month).call
  end

  def call
    stats.data = {
      total: stats_for_total,
      manager: stats_for_manager,
      creditor: stats_for_creditor,
      tipo_objeto: stats_for_tipo_objeto
    }

    stats.save
  end

  def initialize(year, month)
    @year = year
    @month = month
  end

  private

  def stats
    @stats ||= Stats::Contracts::Convenant
      .find_or_initialize_by(month: month, year: year)
  end

  def scope
    Integration::Contracts::Convenant.active_on_month(date)
  end
end
