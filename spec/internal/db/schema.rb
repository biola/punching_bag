ActiveRecord::Schema.define do
  create_table(:articles, force: true) do |t|
    t.string :title
    t.text   :content
    t.timestamps
  end

  create_table(:punches, force: true) do |t|
    t.integer  :punchable_id,   null: false
    t.string   :punchable_type, null: false, limit: 20
    t.datetime :starts_at,      null: false
    t.datetime :ends_at,        null: false
    t.datetime :average_time,   null: false
    t.integer  :hits,           null: false, default: 1
  end

  add_index :punches, [:average_time], name: 'index_punches_on_average_time'
  add_index :punches, [:punchable_type, :punchable_id], name: 'punchable_index'
end