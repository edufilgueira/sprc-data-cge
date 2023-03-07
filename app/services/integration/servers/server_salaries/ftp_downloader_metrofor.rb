require 'net/ftp'

class Integration::Servers::ServerSalaries::FtpDownloaderMetrofor < Integration::Servers::ServerSalaries::FtpDownloader

  FTP_FILE_PREFIXES = {
    arqfun: "ARQFUN*",
    arqfin: "ARQFIN*",
    rubricas: "RUBRICA*"
  }

  def ftp_params(prefix)
    file_prefix = self.class::FTP_FILE_PREFIXES[prefix]

    {
      address: @configuration.send("#{prefix}_ftp_address"),
      user: @configuration.metrofor_ftp_user,
      password: @configuration.metrofor_password_user,
      passive: Rails.env.development? ? true : @configuration.send("#{prefix}_ftp_passive"),
      dir: '/',
      prefix: file_prefix,
      filename: ftp_download_filename(prefix)
    }
  end

  def ftp_download_filename(file_type)
    file_prefix = self.class::FTP_FILE_PREFIXES[file_type]

    file_prefix.gsub('*', "_#{year_month}.txt")
  end
 
end
