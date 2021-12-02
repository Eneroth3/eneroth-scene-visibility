# frozen_string_literal: true

module Eneroth
  module SceneVisibility
    # Helper methods for [Sketchup::Entity].
    module EntityHelper
      # Get a name the user can use to identify an instance.
      #
      # @param instance [Sketchup::group, Sketchup::ComponentInstance]
      #
      # @return [String]
      def self.display_name(instance)
        return instance.definition.name unless instance.is_a?(Sketchup::Group)
        return "Group" if instance.name == "" # TODO: Translate

        instance.name
      end

      # Test if entity is an instance (group or component).
      #
      # @param entity [Sketchup::DrawingElement]
      #
      # @return [Boolean]
      def self.instance?(entity)
        [Sketchup::Group, Sketchup::ComponentInstance].include?(entity.class)
      end
    end
  end
end
