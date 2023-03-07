class AddFtpUserMetroforToIntegrationServersConfiguration < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_servers_configurations, :metrofor_ftp_user, :string
    add_column :integration_servers_configurations, :metrofor_password_user, :string
  end
end
