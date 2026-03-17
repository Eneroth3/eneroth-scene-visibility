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

    EXTENSION.creator     = "Christina Eneroth"
    EXTENSION.description = "Control entity visibility on a per scene basis."
    EXTENSION.version     = "1.0.3"
    EXTENSION.copyright   = "Copyright 2019-2026, Christina Eneroth"
    Sketchup.register_extension(EXTENSION, true)
  end
end
