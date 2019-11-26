require "extensions.rb"

# Eneroth Extensions
module Eneroth
  # Scene Visibility
  module SceneVisibility
    path = __FILE__
    path.force_encoding("UTF-8") if path.respond_to?(:force_encoding)

    # Identifier for this extension.
    PLUGIN_ID = File.basename(path, ".*")

    # Root directory of this extension.
    PLUGIN_ROOT = File.join(File.dirname(path), PLUGIN_ID)

    # Extension object for this extension.
    EXTENSION = SketchupExtension.new(
      "Eneroth Scene Visibility",
      File.join(PLUGIN_ROOT, "main")
    )

    EXTENSION.creator     = "Eneroth"
    EXTENSION.description = "Control entity visibility on a scene basis."
    EXTENSION.version     = "1.0.0"
    EXTENSION.copyright   = "2019, #{EXTENSION.creator}"
    Sketchup.register_extension(EXTENSION, true)
  end
end