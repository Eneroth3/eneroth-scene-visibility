# frozen_string_literal: true

module Eneroth
  module SceneVisibility
    Sketchup.require "#{PLUGIN_ROOT}/vendor/ordbok/ordbok"
    Sketchup.require "#{PLUGIN_ROOT}/vendor/ordbok/lang_menu"

    # Ordbok object.
    OB = Ordbok.new

    Sketchup.require "#{PLUGIN_ROOT}/interface"

    # Reload extension.
    #
    # @param clear_console [Boolean] Whether console should be cleared.
    # @param undo [Boolean] Whether last oration should be undone.
    #
    # @return [void]
    def self.reload(clear_console = true, undo = false)
      # Hide warnings for already defined constants.
      verbose = $VERBOSE
      $VERBOSE = nil
      Dir.glob(File.join(PLUGIN_ROOT, "**/*.{rb,rbe}")).each { |f| load(f) }
      $VERBOSE = verbose

      # Use a timer to make call to method itself register to console.
      # Otherwise the user cannot use up arrow to repeat command.
      UI.start_timer(0) { SKETCHUP_CONSOLE.clear } if clear_console

      Sketchup.undo if undo

      nil
    end

    # Get icon file extension based on SketchUp version and platform.
    #
    # @return [String]
    def self.extension
      if Sketchup.version.to_i < 16
        ".png"
      elsif Sketchup.platform == :platform_win
        ".svg"
      else
        ".pdf"
      end
    end

    unless @loaded
      @loaded = true

      cmd = UI::Command.new(EXTENSION.name) { Interface.toggle }
      cmd.set_validation_proc { Interface.command_state }
      cmd.tooltip = EXTENSION.name
      cmd.status_bar_text = EXTENSION.description
      cmd.large_icon = cmd.small_icon = "#{PLUGIN_ROOT}/images/icon#{extension}"

      UI.add_context_menu_handler do |context_menu|
        context_menu.add_separator
        context_menu.add_item(cmd)
      end

      menu = UI.menu("Plugins").add_submenu(EXTENSION.name)
      menu.add_item(cmd)
      menu.add_separator
      OB.lang_menu(
        menu.add_submenu(OB[:lang_option]),
        system_lang_name: OB[:system_lang_name]
      )

      toolbar = UI::Toolbar.new(EXTENSION.name)
      toolbar.add_item(cmd)
      toolbar.show
    end
  end
end
