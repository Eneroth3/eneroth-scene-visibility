# frozen_string_literal: true

module Eneroth
  module SceneVisibility
    # @private
    module Observers
      def self.observe_model(model)
        @selection_observer ||= SelectionObserver.new
        model.selection.remove_observer(@selection_observer)
        model.selection.add_observer(@selection_observer)

        @pages_observer ||= PagesObserver.new
        model.pages.remove_observer(@pages_observer)
        model.pages.add_observer(@pages_observer)
      end

      def self.unobserve_model(model)
        model.selection.remove_observer(@selection_observer)
        model.pages.remove_observer(@pages_observer)
      end

      def self.observe_app
        @app_observer ||= AppObserver.new
        Sketchup.remove_observer(@app_observer)
        Sketchup.add_observer(@app_observer)
        observe_model(Sketchup.active_model)
      end

      def self.unobserve_app
        Sketchup.remove_observer(@app_observer)
        unobserve_model(Sketchup.active_model)
      end

      # @private
      class SelectionObserver < Sketchup::SelectionObserver
        def onSelectionAdded(_selection, _entity)
          Interface.on_selection_change
        end

        def onSelectionBulkChange(_selection)
          Interface.on_selection_change
        end

        def onSelectionCleared(_selection)
          Interface.on_selection_change
        end

        def onSelectionRemoved(_selection, _entity)
          Interface.on_selection_change
        end

        # HACK: Forward faulty method call.
        def onSelectedRemoved(selection, entity)
          onSelectionRemoved(selection, entity)
        end
      end

      # @private
      class PagesObserver < Sketchup::PagesObserver
        def onContentsModified(_pages)
          Interface.on_scenes_change
        end

        # Adding a scene also calls onContentsModified
        ### def onElementAdded(_pages, _page)
        ###   Interface.on_scenes_change
        ### end

        def onElementRemoved(_pages, _page)
          Interface.on_scenes_change
        end
      end

      # @private
      class AppObserver < Sketchup::AppObserver
        def onActivateModel(model)
          on_activate_model(model)
        end

        def onNewModel(model)
          on_activate_model(model)
        end

        def onOpenModel(model)
          on_activate_model(model)
        end

        private

        def on_activate_model(model)
          Observers.observe_model(model)
          Interface.on_selection_change
        end
      end
    end
  end
end
