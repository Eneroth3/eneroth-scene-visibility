# frozen_string_literal: true

module Eneroth
  module SceneVisibility
    Sketchup.require "#{PLUGIN_ROOT}/visibility"
    Sketchup.require "#{PLUGIN_ROOT}/entity_summary"
    Sketchup.require "#{PLUGIN_ROOT}/observers"

    # User interface for controlling entity visibility on a per scene basis.
    module Interface
      # Show dialog.
      def self.show
        if visible?
          @dialog.bring_to_front
        else
          create_dialog unless @dialog
          @dialog.set_url("#{PLUGIN_ROOT}/dialog.html")
          attach_callbacks
          @dialog.show

          Observers.observe_app
          @dialog.set_on_closed { Observers.unobserve_app }
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
      def self.on_selection_change
        update_dialog
      end

      # Excepted to be called when scenes are added, removed or renamed.
      def self.on_scenes_change
        # Called multiple times on some scene events.
        update_dialog
      end

      # Private

      def self.attach_callbacks
        @dialog.add_action_callback("ready") { update_dialog }
        @dialog.add_action_callback("on_change") do |_, index, state|
          selection = Sketchup.active_model.selection
          scene = Sketchup.active_model.pages[index]
          Visibility.apply_visibility(selection.to_a, [scene], state)
        end
      end
      private_class_method :attach_callbacks

      def self.create_dialog
        @dialog = UI::HtmlDialog.new(
          dialog_title:    EXTENSION.name,
          preferences_key: name, # Full module name
          resizable:       true,
          style:           UI::HtmlDialog::STYLE_DIALOG,
          width:           180,
          height:          250,
          min_width:       150,
          min_height:      200,
          left:            200,
          top:             100
        )
      end
      private_class_method :create_dialog

      def self.update_dialog
        model = Sketchup.active_model
        summary = EntitySummary.summary(model.selection)
        scene_visibility = model.pages.map do |scene|
          [scene.name, Visibility.visible?(model.selection, [scene])]
        end

        @dialog.execute_script(
          "emptySelection = #{model.selection.empty?};"\
          "summary = #{summary.inspect};"\
          "sceneVisibility = #{scene_visibility.to_json};"\
          "update();"
        )
      end
      private_class_method :update_dialog
    end
  end
end
