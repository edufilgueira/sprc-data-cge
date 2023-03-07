require 'rails_helper'
require 'fake_ftp'

describe Integration::Servers::ServerSalaries::FtpDownloader do
  let(:configuration) { create(:integration_servers_configuration, month: '09/2017') }

  let(:downloader) { Integration::Servers::ServerSalaries::FtpDownloader.new(configuration) }

  before do
    # Importante para não alterar o filesystem padrão!
    allow(Rails).to receive(:root).and_return(Dir.mktmpdir)
  end

  describe 'filename' do
    it 'with month' do

      prefix = "ARQFUN05*"
      expected = 'ARQFUN05_201709*'


      expect(downloader.send(:final_filename_regex, prefix)).to eq(expected)
    end
  end

  describe 'file download' do
    let(:filename) { 'ARQFUN05_201709.txt' }
    let(:filedata) { 'test' }

    let(:configuration) do
      create(:integration_servers_configuration, {
        arqfun_ftp_address: "127.0.0.1",
        arqfun_ftp_passive: false,
        arqfun_ftp_dir: "/",
        arqfun_ftp_user: "user",
        arqfun_ftp_password: "pass",
        month: '09/2017'
      })
    end

    let(:server) { FakeFtp::Server.new(21222) }

    before do
      server.add_file(filename, filedata)
      server.start

      expect(server.files).to include('ARQFUN05_201709.txt')
    end

    after do
      server.stop
    end

    it 'downloads a file' do
      ftp = Net::FTP.new
      ftp.connect('127.0.0.1', 21222)
      ftp.login('user', 'pass')
      ftp.passive = false

      file_dest = configuration.download_path

      saved_file = "#{file_dest}/#{filename}"

      downloader.ftp_port = 21222

      downloader.download_file(:arqfun)

      expect(File.read(saved_file)).to eq(filedata)
    end
  end
end
