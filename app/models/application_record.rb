class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.sort_by_params(column, direction)
    sortable_column = column.presence_in(sortable_columns) || "created_at"
    order(sortable_column => direction)
  end

  def self.sortable_columns
    @sortable_columns ||= columns.map(&:name)
  end
end
