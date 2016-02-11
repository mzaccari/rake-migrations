[![Build Status](https://travis-ci.org/mzaccari/rake-task-migrations.svg?branch=master)](https://travis-ci.org/mzaccari/rake-task-migrations)
[![Code Climate](https://codeclimate.com/github/mzaccari/rake-task-migrations/badges/gpa.svg)](https://codeclimate.com/github/mzaccari/rake-task-migrations)
[![Test Coverage](https://codeclimate.com/github/mzaccari/rake-task-migrations/badges/coverage.svg)](https://codeclimate.com/github/mzaccari/rake-task-migrations/coverage)

# Rake Task Migrations

Heavily based on the `seed_migration` gem [found here](https://github.com/harrystech/seed_migration).

For rails projects that need to run tasks on deployment that don't quite fit in the `db:migrate` and `seed:migrate` categories, this gem migrates specified rake tasks and ensures they only run once.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rake-task-migration'
```

And then execute:

    $ bundle

Install and run the internal migrations

    $ bundle exec rake task_migration:install:migrations
    $ bundle exec rake db:migrate

That will create the table to keep track of rake task migrations.

## Usage

Create the `lib/tasks/migrations.rake` file and add your tasks:

```ruby
namespace :migrations do
  task :migrate_user_names => :environment do
    User.find_each do |user|
      user.update_attributes(name: "#{user.first_name} #{user.last_name}")
    end
  end
end
```

Then run the migration for your rake tasks:

```
$ bundle exec rake tasks:migrate
== migrate_user_names: migrating =============================================
== migrate_user_names: migrated (0.0191s) ====================================
```

Each rake task is run only once.

## Configuration

Use an initializer file for configuration.

### List of available configurations :

- `migration_table_name (default = 'rake_task_migrations')`
- `migration_namespace (default = :migrations)`

#### Example:

```ruby
# config/initializers/rake_task_migration.rb

Rake::TaskMigration.config do |config|
  config.migration_table_name = 'table_name'
  config.migration_namespace  = 'namespace'
end
```

## Runnings tests

```bash
export RAILS_ENV=test
bundle exec rake app:db:create app:db:migrate
bundle exec rspec spec
```

## Supported Versions

* Ruby 2.0, 2.1, 2.2
* Rails 3.2, 4.0, 4.1, 4.2

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

