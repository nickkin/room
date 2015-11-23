Refile.cache = Refile::Backend::FileSystem.new('public/uploads/cache', max_size: 10.megabytes)
Refile.store = Refile::Backend::FileSystem.new('public/uploads/store', max_size: 10.megabytes)