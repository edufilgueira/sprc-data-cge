# Configura o local de armazenamento dos anexos para a pasta _uploads_
# Padrão: tmp/uploads

uploads_path = Rails.root.join('uploads').to_s

Refile.store = Refile::Backend::FileSystem.new("#{uploads_path}/store")
Refile.cache = Refile::Backend::FileSystem.new("#{uploads_path}/cache")
