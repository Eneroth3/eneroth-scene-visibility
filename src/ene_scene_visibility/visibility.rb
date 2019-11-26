module Eneroth
  module SceneVisibility
    module Visibility
      # Check if entities are shown or hidden in scenes.
      #
      # @param entities [Array<Sketchup::DrawingElement>, Sketchup::Selection]
      # @param scenes [Array<Sketchup::Page>], Sketchup::Pages]
      #
      # @example
      #   visible?(Sketchup.active_model.selection.to_a,
      #            Sketchup.active_model.pages)
      #
      # @return [Boolean, nil] nil denotes values differ between scenes or
      #   entities.
      def self.visible?(entities, scenes)
        # Hidden contains duplicates if the same entity is hidden in multiple
        # scenes.
        hidden = scenes.flat_map(&:hidden_entities)
        # Not using Array & as it removes duplicates.
        intersection = hidden.select { |e| entities.include?(e) }
        return false if intersection.size == entities.size * scenes.size
        return true if intersection.empty?
      end

      # Apply visibility state to entities on a scene basis.
      #
      # @param entities [Array<Sketchup::DrawingElement>, Sketchup::Selection]
      # @param scenes [Array<Sketchup::Page>], Sketchup::Pages]
      # @param state [Boolean]
      def self.apply_visibility(entities, scenes, state)
        # Not yet implemented.
        # https://github.com/SketchUp/api-issue-tracker/issues/376
        entities.each { |e| scenes.each { |s| s.set_visibility(e, state) } }
      end
    end
  end
end
