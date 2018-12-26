
task :deploy do
  stage = ENV['stage'].nil? ? 'dev' : ENV['stage']
  puts "Deploying to #{stage}..."

  print 'Removing vendor folder... '
  system 'rm -Rf vendor'
  puts 'done!'

  puts 'Downloading dependencies... '
  if system 'bundle install --path vendor/bundle --without test development'
    puts 'Downloading dependencies... done!'

    puts 'Building and deploying... '
    system "sls deploy --stage #{stage}"
    puts 'Building and deploying... done!'

    print 'Unlocking Gemfile... '
    system 'bundle install --quiet --with test development'
    puts 'done!'
  end
end
