require 'active_support/concern'
require 'active_record'

module MultipleDefaultScopes
  extend ActiveSupport::Concern
  
  module ClassMethods
    ##  class ModelName < ActiveRecord::Base
    ##    is_paranoid
    ##    default_scope :order => "#{ModelName.quoted_table_name}.name"
    ##    allows_multiple_default_scopes # this calls alias_method_chain and hooks into our default scoping etc.
    ##  end
    def allows_multiple_default_scopes
      class_eval do
        
        class << self
          def default_scoping_with_deep_merge
            [] do |default_scope|
              merged_default_scopes = {}

              default_scoping_without_deep_merge.each do |scope|
                merged_default_scopes = merged_default_scopes.deep_merge(scope)
              end

              default_scoping << merged_default_scopes
            end
            return default_scoping
          end

          alias_method_chain :default_scoping, :deep_merge
        end
      end
    end
  end
end


ActiveSupport.on_load(:active_record) { include MultipleDefaultScopes }