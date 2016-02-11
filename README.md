[![Code Climate](https://codeclimate.com/github/mzaccari/rake-task-migrations/badges/gpa.svg)](https://codeclimate.com/github/mzaccari/rake-task-migrations) [![Test Coverage](https://codeclimate.com/github/mzaccari/rake-task-migrations/badges/coverage.svg)](https://codeclimate.com/github/mzaccari/rake-task-migrations/coverage) [![Build Status](https://travis-ci.org/mzaccari/rake-task-migrations.svg?branch=master)](https://travis-ci.org/mzaccari/rake-task-migrations)

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

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mzaccari/rake-task-migrations.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

