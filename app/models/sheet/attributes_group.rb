# frozen_string_literal: true

module Sheet
  class AttributesGroup
    include EmbeddedModel

    attr_accessor :name, :order, :page, :instructions,
      :show_on_posts, :order_on_posts, :show_title_on_posts, :attributes_points_formula,
      :group_points_formula, :character_attributes, :list, :equipments,

      # The position on the sheet where the group will appear.
      #
      # Valid positions are: header, column_1, column_2, column_3 and footer
      :position,

      # The game master can deliberatedly add extra points to any attributes
      # group. This attribute will be added on a character sheet, not on the
      # game system.
      :extra_points,

      # The type indicates what kind of attributes the group will hold.
      # Each attribute type has its own behavior. The valid types are:
      #
      # TODO: list all attribute types here
      :type,

      # All groups are fed by a source, and there are many different source types.
      # This attribute is responsible to allow the group to find the correct
      # source. The valid source types are:
      #
      # TODO: list all source types here`
      :source_type

      # These attributes are not stored in the database. They are calculated
      # at the end of the sheet initialization, linking attributes that are
      # based in others and calculating the formulas as well

      # Points will hold the result of the group_points_formula
      attr_accessor :points

      # Extra fields not stored in the database:
      attr_accessor :quick_access

      def show_on_posts?
        !!show_on_posts
      end

      def used_points
        @used_points ||= begin
          return 0 if character_attributes.blank? || group_points_formula.blank?

          character_attributes.reduce(0) { |sum, attribute| sum += attribute.cost || attribute.points.to_i }
        end
      end

      def total_points
        points.to_i + extra_points.to_i
      end

      def to_params(options = {})
        {
          group_name: name,
          # Points are not set from inside the class. They are calculated
          # on the Sheet class, inside the `calculate_group_points` method,
          # because it is necessary to access attributes from other groups to
          # parse the formulas. Because of that, accessing only this class the
          # points will always be `nil` unless the Sheet method is called.
          points: points,
          used_points: used_points,
          source_type: source_type,
          type: type
        }.merge(options)
      end

      private

      def nested_attributes
        %w(character_attributes list equipments)
      end
  end
end
