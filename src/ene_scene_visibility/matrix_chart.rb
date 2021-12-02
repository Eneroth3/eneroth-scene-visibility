module Eneroth
  module SceneVisibility
    # Data structure for a table with labeled axes.
    # This can roughly be thought of as a 2D hash.
    #
    # @example
    #   # Creates this table
    #   #        Legs Eyes
    #   # Cat       4    2
    #   # Dog       4    2
    #   # Human     2    2
    #   # Spider    8    8
    #   col_keys = ["Legs", "Eyes"]
    #   row_keys = ["Cat", "Dog", "Human", "Spider"]
    #   data = [
    #     [4, 2],
    #     [4, 2],
    #     [2, 2],
    #     [8, 8]
    #   ]
    #   matrix = MatrixChart.new(col_keys, row_keys, data)
    class MatrixChart
      # Create a MatrixChart.
      #
      # @param col_keys [Array<Object>]
      # @param row_keys [Array<Object>]
      # @param data [Array<Array>]
      #   Row major 
      def initialize(col_keys, row_keys, data)
        @col_keys = col_keys
        @row_keys = row_keys
        @data = data
        
        # TODO: Raise if sizes don't match.
        # TODO. Raise on duplicate keys
      end
      
      # Get the row keys.
      #
      # @return [Array]
      def row_keys
        @row_keys
      end
      
      # Get the row data.
      #
      # @return [Array]
      def rows
        @data
      end
      
      # Get the col keys.
      #
      # @return [Array]
      def col_keys
        @col_keys
      end
      
      # Get the col data.
      #
      # @return [Array]
      def cols
        @data.transpose
      end
      
      # Sort the matrix rows.
      #
      # @example
      #   # Sort rows by key
      #   matrix.sort_rows!
      #
      #   # Sort rows by values
      #   matrix.sort_rows! { |k, v| v }
      #
      #   # Sort rows by value in first cell
      #   matrix.sort_rows! { |k, v| v[0] }
      #
      # @return [Self]
      def sort_rows!
        rows_with_keys = [row_keys, rows]
        # TODO: Handle block missing.
        rows_with_keys = rows_with_keys.sort_by { |k, v| yield(k, v) }
        
        @row_keys = rows_with_keys.map { |rwk| rwk[0] }
        @data = rows_with_keys.map { |rwk| rwk[1] }
        
        self
      end
      
      # Sort the matrix cols.
      #
      # @example
      #   # Sort cols by key
      #   matrix.sort_cols!
      #
      #   # Sort cols by values
      #   matrix.sort_cols! { |k, v| v }
      #
      #   # Sort cols by value in first cell
      #   matrix.sort_cols! { |k, v| v[0] }
      #
      # @return [Self]
      def sort_cols!(&block)
        transpose!
        sort_rows(&block)
        transpose!
        
        self
      end
      
      # Get value by indices
      #
      # @param row [Integer]
      # @param col [Integer]
      #
      # @return [Object]
      def [](row, col)
        @data[row, col]
      end
      
      # Get value by keys
      #
      # @param row_key [Object]
      # @param col_key [Object]
      #
      # @return [Object]
      def fetch(row_key, col_key)
        row = row_keys.index(row_key)
        row = col_keys.index(col_key)
        
        # TODO: Raise if no such key.
        
        self[row, col]
      end
      
      # Check if two matrix charts hold the same data.
      #
      # @return [Boolean]
      def ==(other)
        rows == other.rows &&
        row_keys == other.row_keys &&
        col_keys == other.col_keys
      end
      
      # Swap rows and cols.
      #
      # @return [Self]
      def transpose!
        @row_keys, @col_keys = @col_keys, @row_keys
        @data = @data.transpose
        
        self
      end
      
      # Format keys and values for debugging purposes.
      #
      # @return [String]
      def inspect
        # Get widths for all columns
        # col_widths = 
        # Add padding to values
        # Right justify numbers?
      end
      
      private
      
      def inspect_value(value)
        case value
        when TrueClass
          "T"
        when FalseClass
          "F"
        when Float
          value.round(2)
        else
          value.inspect
        end
      end
    end
  end
end
