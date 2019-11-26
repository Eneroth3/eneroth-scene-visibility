module Eneroth
  module SceneVisibility
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
        curves = entities.select { |e| e.respond_to?(:curve) }.map(&:curve).uniq

        if (classes & [Sketchup::Group, Sketchup::ComponentInstance]).size == 2
          OB["entity_summary.group_component", count: entities.size]
        elsif curves.size == 1
          OB["entity_summary.curve"]
        elsif classes.size == 1
          OB["entity_summary.#{class_name}", count: entities.size]
        elsif entities.size == 0
          OB["entity_summary.no_selection"]
        else
          OB["entity_summary.entities", count: entities.size]
        end
      end
    end
  end
end
