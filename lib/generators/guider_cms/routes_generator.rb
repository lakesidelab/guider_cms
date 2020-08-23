require 'rails/generators/base'

module GuiderCms
  module Generators
    MissingORMError = Class.new(Thor::Error)

    class RoutesGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../config/", __FILE__)

      desc "Creates a GuiderCms routes in your application."
      class_option :orm, required: true

      def copy_initializer
        unless options[:orm]
          raise MissingORMError, <<-ERROR.strip_heredoc
          An ORM must be set to install GuiderCms in your application.
          Be sure to have an ORM like Active Record or Mongoid loaded in your
          app or configure your own at `config/application.rb`.
            config.generators do |g|
              g.orm :your_orm_gem
            end
          ERROR
        end

        template "routes.rb", "config/guider_cms/routes.rb"
      end


      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
