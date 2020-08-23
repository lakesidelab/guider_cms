require 'rails/generators/base'

module GuiderCms
  module Generators
    class ControllerGenerator < Rails::Generators::Base

      source_root File.expand_path("../../../../app/controllers/", __FILE__)

      argument :scope, required: false, default: nil,
                         desc: "The scope to copy views to"

      def copy_views
        view_directory :guider_cms
      end

      protected

      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}" do |content|
          content
        end
      end

      def target_path
        @target_path ||= "app/controllers/"
      end

      def plural_scope
        @plural_scope ||= scope.presence && scope.underscore.pluralize
      end
    end
  end
end
