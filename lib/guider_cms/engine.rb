module GuiderCms
  class Engine < ::Rails::Engine
    isolate_namespace GuiderCms

    initializer "engine_name.assets.precompile" do |app|
      app.config.assets.precompile += %w( guider_cms/application.css guider_cms/up.png guider_cms/down.png )
    end
  end
end
