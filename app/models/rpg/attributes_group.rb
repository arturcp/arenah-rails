module RPG
  class AttributesGroup
    include EmbeddedModel

    attr_accessor :name, :order, :position, :page, :instructions,
      :show_on_posts, :order_on_posts, :attributes_points_formula,
      :group_points_formula, :character_attributes, :list, :equipments,

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
      :source_type,

      # These attributes are not stored in the database. They are calculated
      # at the end of the sheet initialization, linking attributes that are
      # based in others and calculating the formulas as well

      # points will hold the result of the group_points_formula
      :points

      def show_on_posts?
        !!show_on_posts
      end

      def used_points
        @used_points ||= begin
          return 0 if character_attributes.blank?

          character_attributes.reduce(0) {|sum, attribute| sum += attribute.points.to_f }
        end
      end

      def total_points
        points.to_i + extra_points.to_i
      end

      private

      def nested_attributes
        %w(character_attributes list equipments)
      end
  end
end