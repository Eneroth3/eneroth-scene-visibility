module Eneroth
  module SceneVisibility
    Sketchup.require "#{PLUGIN_ROOT}/visibility"
    Sketchup.require "#{PLUGIN_ROOT}/entity_helper"


    entities = Sketchup.active_model.active_entities.to_a
    entities.select! { |e| e.layer.visible? && EntityHelper.instance?(e) }
    entities = entities.sort_by { |e| EntityHelper.display_name(e) }
    scenes = Sketchup.active_model.pages

    matrix = Visibility.visibility_matrix(entities, scenes)

    html = "<table border=\"1\">"

    # X axis (top row)
    html += "<tr><td></td>"
    scenes.each { |s| html += "<td>#{s.name}</rd>" }
    html += "</tr>"

    entities.each_with_index do |entity, i|
      # Y axis (first cell)
      html += "<tr><td>#{EntityHelper.display_name(entity) }</td>"
      
      matrix[i].each { |v| html += "<td>#{v ? 'X' : ''}</td>"}
      html += "</tr>"
    end
    html += "</table>"

    puts html


  end
end
