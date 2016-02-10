module Rake
  module TaskMigration
    class Migrator
      class << self
        def migrate(tasks)
          new(tasks).migrate
        end

        def rake_task_migrations_table_name
          RakeTaskMigration.table_name
        end

        def get_all_tasks(connection = ActiveRecord::Base.connection)
          ActiveSupport::Deprecation.silence do
            if connection.table_exists?(rake_task_migrations_table_name)
              RakeTaskMigration.all.map { |x| x.version.to_s }.sort
            else
              []
            end
          end
        end
      end

      attr_reader :tasks

      def initialize(tasks)
        @tasks = Array(tasks)
      end

      def migrate
        pending_tasks.each { |task| migrate_task(task.name.to_s) }
      end

      private

      def migrate_task(task)
        raise "#{task} has already been migrated." if RakeTaskMigration.where(version: task).first

        announce "#{task}: migrating"

        ActiveRecord::Base.transaction do
          time = Benchmark.measure do
            invoke(task)
          end

          # Create record
          migration = RakeTaskMigration.new
          migration.version = task
          migration.runtime = time.real.to_i
          migration.migrated_on = DateTime.now
          begin
            migration.save!
          rescue StandardError => e
            puts e
          end

          announce "#{task}: migrated (%.4fs)" % time.real;
        end
      end

      def invoke(task)
        Rake::Task[task].invoke
      end

      def pending_tasks
        already_migrated = migrated
        tasks.reject { |task| already_migrated.include?(task.name) }
      end

      def migrated
        @migrated_tasks || load_migrated
      end

      def load_migrated
        @migrated_tasks = Set.new(self.class.get_all_tasks)
      end

      def write(text)
        puts(text)
      end

      def announce(text)
        length = [0, 75 - text.length].max
        write "== %s %s" % [text, "=" * length]
      end
    end
  end
end
