namespace :pull_data do
  desc "Run all data pulls for seeding database"
  task all: :environment do
    Rake::Task["pull_data:map_geojson"].execute
    Rake::Task["pull_data:census_migration_2010"].execute
    Rake::Task["pull_data:census_poverty_2010"].execute
    Rake::Task["pull_data:census_education_2012"].execute
    Rake::Task["pull_data:census_marital_2013"].execute
    Rake::Task["pull_data:twitter_poverty"].execute
    Rake::Task["pull_data:twitter_education"].execute
    Rake::Task["pull_data:twitter_migration"].execute
    Rake::Task["pull_data:twitter_marital"].execute
  end

  desc "Run all twitter data pulls for updating database"
  task all_twitter: :environment do
    Rake::Task["pull_data:twitter_poverty"].execute
    Rake::Task["pull_data:twitter_education"].execute
    Rake::Task["pull_data:twitter_migration"].execute
    Rake::Task["pull_data:twitter_marital"].execute
  end

  desc "Pull base map data and save to MapState model"
  task map_geojson: :environment do
    puts "Pulling geojson map data..."
    MapState.delete_all
    MapService.save_map_data
    puts "Map data pulled! There are now #{MapState.count} records in the MapState model."
  end

  desc "Pull 2010 census migration data and save to StateMigrationData model"
  task census_migration_2010: :environment do
    puts "Pulling census migration data..."
    StateMigrationData.destroy_all(year: 2010)
    CensusService.new.save_migration_data(2010)
    puts "Data pulled! There are now #{StateMigrationData.where(year: 2010)
      .count} records in the StateMigrationData model"
  end

  desc "Pull 2010 census poverty data and save to StatePovertyData model"
  task census_poverty_2010: :environment do
    puts "Pulling census poverty data..."
    StatePovertyData.destroy_all(year: 2010)
    CensusService.new.save_poverty_data(2010)
    puts "Data pulled! There are now #{StatePovertyData.where(year: 2010)
      .count} records in the StatePovertyData model."
  end

  desc "Pull 2012 census education data and save to StateEducationData model"
  task census_education_2012: :environment do
    puts "Pulling census education data..."
    StateEducationData.destroy_all(year: 2012)
    CensusService.new.save_education_data(2012)
    puts "Data pulled! There are now #{StateEducationData.where(year: 2012)
      .count} records in the StateEducationData model."
  end

  desc "Pull 2013 census marital data and save to StateMaritalData model"
  task census_marital_2013: :environment do
    puts "Pulling census marital data..."
    StateMaritalData.destroy_all(year: 2013)
    CensusService.new.save_marital_data(2013)
    puts "Data pulled! There are now #{StateMaritalData.where(year: 2013)
      .count} records in the StateMaritalData model."
  end

  desc "Pull poverty twitter data and save to Tweet model"
  task twitter_poverty: :environment do
    puts "Pulling twitter poverty data..."
    Tweet.destroy_all(dataset: "poverty")
    TwitterService.new.find("poverty")
    puts "Twitter poverty data pulled! There are now #{Tweet
      .where(dataset: "poverty").count} records in the Tweet model for poverty."
  end

  desc "Pull eduction twitter data and save to Tweet model"
  task twitter_education: :environment do
    puts "Pulling twitter education data..."
    Tweet.destroy_all(dataset: "education")
    TwitterService.new.find("education")
    puts "Twitter education data pulled! There are now #{Tweet
      .where(dataset: "education").count} records in the Tweet model for education."
  end

  desc "Pull migration twitter data and save to Tweet model"
  task twitter_migration: :environment do
    puts "Pulling twitter migration data..."
    Tweet.destroy_all(dataset: "migration")
    TwitterService.new.find("migration")
    puts "Twitter migration data pulled! There are now #{Tweet
      .where(dataset: "migration").count} records in the Tweet model for migration."
  end

  desc "Pull marital twitter data and save to Tweet model"
  task twitter_marital: :environment do
    puts "Pulling twitter marital data..."
    Tweet.destroy_all(dataset: "marital")
    TwitterService.new.find("marital")
    puts "Twitter marital data pulled! There are now #{Tweet
      .where(dataset: "marital").count} records in the Tweet model for marital."
  end
end
