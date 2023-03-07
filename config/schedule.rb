require File.expand_path('../environment', __FILE__)

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "#{path}/log/cron.log"

# Integration::CityUndertakings
cron_syntax_frequency = Integration::CityUndertakings::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::CityUndertakings::ImporterWorker.perform_async"
  end
end

# Integration::Constructions
cron_syntax_frequency = Integration::Constructions::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Constructions::ImporterWorker.perform_async"
  end
end

# Integration::Contracts
cron_syntax_frequency = Integration::Contracts::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Contracts::ImporterWorker.perform_async"
  end
end

# Integration::Eparcerias
cron_syntax_frequency = Integration::Eparcerias::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Eparcerias::ImporterWorker.perform_async"
  end
end

# Integration::Expenses
cron_syntax_frequency = Integration::Expenses::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Expenses::ImporterWorker.perform_async"
  end
end

# Integration::Purchases
cron_syntax_frequency = Integration::Purchases::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Purchases::ImporterWorker.perform_async"
  end
end

# Integration::Revenues
cron_syntax_frequency = Integration::Revenues::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Revenues::ImporterWorker.perform_async"
  end
end

# Integration::RealStates
cron_syntax_frequency = Integration::RealStates::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::RealStates::ImporterWorker.perform_async"
  end
end


# Integration::Servers
cron_syntax_frequency = Integration::Servers::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Servers::ImporterWorker.perform_async"
  end
end

# Integration::Supports::Creditor
cron_syntax_frequency = Integration::Supports::Creditor::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Supports::Creditor::ImporterWorker.perform_async"
  end
end

# Integration::Supports::Domain
cron_syntax_frequency = Integration::Supports::Domain::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Supports::Domain::ImporterWorker.perform_async"
  end
end

# Integration::Supports::Organ
cron_syntax_frequency = Integration::Supports::Organ::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Supports::Organ::ImporterWorker.perform_async"
  end
end

# Integration::Supports::Axis
cron_syntax_frequency = Integration::Supports::Axis::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Supports::Axis::ImporterWorker.perform_async"
  end
end

# Integration::Supports::Theme
cron_syntax_frequency = Integration::Supports::Theme::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Supports::Theme::ImporterWorker.perform_async"
  end
end

# Integration::Results
cron_syntax_frequency = Integration::Results::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Results::ImporterWorker.perform_async"
  end
end


# Integration::Macroregions
cron_syntax_frequency = Integration::Macroregions::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Macroregions::ImporterWorker.perform_async"
  end
end



# ------------
# ------------
# [begin] PPA
# ------------
# ------------

# Integration::PPA::Source::AxisTheme
cron_syntax_frequency = Integration::PPA::Source::AxisTheme::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::PPA::Source::AxisTheme::ImporterWorker.perform_async"
  end
end

# Integration::PPA::Source::Guideline
cron_syntax_frequency = Integration::PPA::Source::Guideline::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::PPA::Source::Guideline::ImporterWorker.perform_async"
  end
end

# Integration::PPA::Source::Region
cron_syntax_frequency = Integration::PPA::Source::Region::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::PPA::Source::Region::ImporterWorker.perform_async"
  end
end

# ----------
# ----------
# [end] PPA
# ----------
# ----------


cron_syntax_frequency = Integration::Outsourcing::MonthlyCosts::Configuration.first_or_initialize.cron_syntax_frequency
if cron_syntax_frequency.present?
  every cron_syntax_frequency do
    runner "Integration::Outsourcing::ImporterWorker.perform_async"
  end
end


every :day, at: ['8:00 am', '3:00 pm']  do
  runner "Integration::StatusReportWorker.perform_async"
end