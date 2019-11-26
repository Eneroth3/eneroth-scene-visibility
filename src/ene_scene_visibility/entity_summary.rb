# frozen_string_literal: true

module Eneroth
  module SceneVisibility
    # Summarize entities, like Entity Info does.
    module EntitySummary
      # Summarize what entities are, similar to what Entity Info does.
      #
      # @param entities [Array<Sketchup::DrawingElement>, Sketchup::Selection]
      #
      # @example
      #   summary(Sketchup.active_model.selection)
      #
      # @return [String]
      def self.summary(entities)
        classes = entities.map(&:class).uniq
        class_name = classes.first.to_s.split("::").last
        curves = entities.map { |e| e.respond_to?(:curve) && e.curve }.uniq

        if (classes & [Sketchup::Group, Sketchup::ComponentInstance]).size == 2
          OB["entity_summary.group_component", count: entities.size]
        elsif curves.size == 1 && curves.first
          OB["entity_summary.curve"]
        elsif classes.size == 1
          OB["entity_summary.#{class_name}", count: entities.size]
        elsif entities.empty?
          OB["entity_summary.no_selection"]
        else
          OB["entity_summary.entities", count: entities.size]
        end
      end
    end
  end
end
