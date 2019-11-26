require "cgi"

module Eneroth
  module SceneVisibility
    Sketchup.require "#{PLUGIN_ROOT}/visibility"
    Sketchup.require "#{PLUGIN_ROOT}/entity_summary"

    # User interface for controlling entity visibility on a per scene basis.
    module Interface
      # Show dialog.
      def self.show
        if @dialog && @dialog.visible?
          @dialog.bring_to_front
        else
          create_dialog unless @dialog
          @dialog.set_url("#{PLUGIN_ROOT}/dialog.html")
          attach_callbacks
          @dialog.show
        end
      end

      # Hide dialog.
      def self.hide
        @dialog.close
      end

      # Check whether dialog is visible.
      #
      # @return [Boolean]
      def self.visible?
        @dialog && @dialog.visible?
      end

      # Toggle visibility of dialog.
      def self.toggle
        visible? ? hide : show
      end

      # Get SketchUp UI command state for dialog visibility state.
      #
      # @return [MF_CHECKED, MF_UNCHECKED]
      def self.command_state
        visible? ? MF_CHECKED : MF_UNCHECKED
      end

      # Excepted to be called when selection changes.
      def on_selection_change
        # TODO: Invoke.
        update_dialog
      end

      # Excepted to be called when scenes are added, removed or renamed.
      def on_scenes_change
        # TODO: Invoke.
        update_dialog
      end

      # Private

      def self.attach_callbacks
        @dialog.add_action_callback("ready") { update_dialog }
        # TODO: Add callback for changing visibility.
      end

      def self.create_dialog
        @dialog = UI::HtmlDialog.new(
          dialog_title:    EXTENSION.name,
          preferences_key: name, # Full module name
          resizable:       true,
          style:           UI::HtmlDialog::STYLE_DIALOG,
          width:           180,
          height:          250,
          left:            200,
          top:             100
        )
      end

      def self.update_dialog
        summary = EntitySummary.summary(Sketchup.active_model.selection)
        js = "set_summary('#{CGI.escapeHTML(summary)}');"
        @dialog.execute_script(js)
        # TODO: Set content.
      end
    end
  end
end
