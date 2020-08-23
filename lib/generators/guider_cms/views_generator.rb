require 'rails/generators/base'

module GuiderCms
  module Generators
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path("../../../../app/views/guider_cms", __FILE__)

      argument :scope, required: false, default: nil,
                         desc: "The scope to copy views to"

      def copy_views
        view_directory :articles
        view_directory :categories
        view_directory :subcategories
      end

      protected

      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/guider_cms/#{name}" do |content|
          content
        end
      end

      def target_path
        @target_path ||= "app/views/#{plural_scope}"
      end

      def plural_scope
        @plural_scope ||= scope.presence && scope.underscore.pluralize
      end
    end
  end
end
