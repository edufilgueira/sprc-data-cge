class Integration::Servers::Workers::StatsWorker < Integration::Servers::ServerSalaries::CreateStats
  include Sidekiq::Worker

  sidekiq_options queue: 'servers_import'

  def initialize()

  end

  def perform(year, month)
    @year = year
    @month = month

    self.call
  end
end
