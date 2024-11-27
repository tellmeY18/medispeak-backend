class AddValidationFieldsToFormFields < ActiveRecord::Migration[8.0]
  def change
    add_column :form_fields, :friendly_name, :string
    add_column :form_fields, :field_type, :string, null: false, default: 'string'

    # For number fields
    add_column :form_fields, :minimum, :string
    add_column :form_fields, :maximum, :string

    # For select fields
    add_column :form_fields, :enum_options, :string, array: true, default: []

    # Copy existing title values to friendly_name
    FormField.find_each do |field|
      field.update_column(:friendly_name, field.title)
    end

    # Make friendly_name required after copying data
    change_column_null :form_fields, :friendly_name, false
  end
end
