#set_visibility(layer, visibility)
Sketchup.active_model.pages.selected_page.hidden_entities



# Check if entities are shown or hidden in scenes.
#
# @return [Boolean, nil] nil denotes values differ between scenes or entities.
def visible?(entities, scenes)
  hidden = scenes.flat_map(&:hidden_entities)
  intersection = entities & hidden

  return true if intersection.empty?
  return false if intersection == entities
end

# Check if entities are shown or hidden in scenes.
#
# @return [Boolean, nil] nil denotes values differ between scenes or entities.
def visible?(entity, scenes)
  included = nil
  excluded = nil
  scenes.each do |scene|
    state = scene.hidden_entities.include?(entity)
    included = true if state
    excluded = true unless state
    return if included && excluded
  end

  included
end

entities.each do |entity|
  overlap = hidden.count(entity)
  return unless overlap == scenes.size
end


# Check if entities are shown or hidden in scenes.
#
# @return [Boolean, nil] nil denotes values differ between scenes or entities.
def visible?(entities, scenes)
  # Hidden contains duplicates if the same entity is hidden in multiple scenes.
  hidden = scenes.flat_map(&:hidden_entities)
  # TODO: Need to limit hidden to entities, but with duplicates, for this to work.
  return false if hidden.size == entities.size * scenes.size
  intersection = entities & hidden
  return true if intersection.empty?
end


# Check if entities are shown or hidden in scenes.
#
# @param entities [Array<Sketchup::DrawingElement>, Sketchup::Selection]
# @param scenes [Array<Sketchup::Page>], Sketchup::Pages]
#
# @example
#   visible?(Sketchup.active_model.selection.to_a, Sketchup.active_model.pages)
#
# @return [Boolean, nil] nil denotes values differ between scenes or entities.
def visible?(entities, scenes)
  # Hidden contains duplicates if the same entity is hidden in multiple scenes.
  hidden = scenes.flat_map(&:hidden_entities)
  # Not using Array & as it removes duplicates.
  intersection = hidden.select { |e| entities.include?(e) }
  return false if intersection.size == entities.size * scenes.size
  return true if intersection.empty?
end








