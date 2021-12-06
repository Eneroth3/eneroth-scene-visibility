module Eneroth
  module SceneVisibility
    Sketchup.require "#{PLUGIN_ROOT}/visibility"
    Sketchup.require "#{PLUGIN_ROOT}/entity_helper"
    
    # Sort two arrays in parallel.
    #
    # @param array1 [Array]
    # @param array2 [Array]
    #
    # @yieldparam value1
    #   A value in array1
    # @yieldparam value2
    #   The corresponding value in array2
    #
    #  @example
    #    animals = ["Spider", "Cat", "Human", "Dog"]
    #    legs = [8, 4, 2, 4]
    #
    #    # Sort by legs
    #    animals, legs = parallel_sort(array1, array2) { |a, l| l }
    #    array1 #=> ["Human", "Cat", "Dog", "Spider"]
    #    array2 #=> [2, 4, 4, 8]
    #
    #    # Sort alphabetically
    #    animals, legs = parallel_sort(array1, array2) { |a, l| a }
    #    array1 #=> ["Cat", "Dog", "Human", "Spider"]
    #    array2 #=> [4, 4, 2, 8]
    def self.parallel_sort(array1, array2)
      parallel_arrays = array1.zip(array2)
      parallel_arrays = parallel_arrays.sort_by { |values| yield(*values) }
      
      parallel_arrays.transpose
    end



    entities = Sketchup.active_model.active_entities.to_a
    entities.select! { |e| e.layer.visible? && EntityHelper.instance?(e) }
    entities = entities.sort_by { |e| EntityHelper.display_name(e) }
    scenes = Sketchup.active_model.pages
    matrix = Visibility.visibility_matrix(entities, scenes)
    
    # Sort by visibility states
    entities, matrix = parallel_sort(entities, matrix) do |_, row|
      # Convert boolean array to binary array, to allow arrays to be sorted.
      # Negate values to have show visible entities first.
      row.map { |v| v ? -1 : 0 }
    end



    html = "<table border=\"1\">"

    # X axis (top row)
    html += "<tr><td></td>"
    scenes.each { |s| html += "<td>#{s.name}</rd>" }
    html += "</tr>"

    entities.each_with_index do |entity, i|
      # Y axis (first cell)
      html += "<tr><td>#{EntityHelper.display_name(entity) }</td>"
      
      matrix[i].each do |v|
        html += "<td>"
        html += "<input type=\"checkbox\" disabled #{v ? 'checked' : ''}/></td>"
      end
      html += "</tr>"
    end
    html += "</table>"

    @dialog = UI::HtmlDialog.new(preferences_key: name)
    @dialog.set_html(html)
    @dialog.show
  end
end
