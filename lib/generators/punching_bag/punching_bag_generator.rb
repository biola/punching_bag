require 'rails/generators'
require 'rails/generators/migration'

class PunchingBagGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.join(File.dirname(__FILE__), 'templates')

  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  def create_migration_file
    migration_template 'create_punches_table.rb', 'db/migrate/create_punches_table.rb'
  end
end
