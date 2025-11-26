module Views
  module DefaultCruds
    class Index < Views::Base
      def page_title
        data.model_name.human(count: 2) if data.respond_to?(:model_name)
      end

      def view_template(&)
        render Table.new(data) { |table| setup_columns(table) }
      end

      private

      def setup_columns(table)
        model_class = data.model

        model_class.attribute_names.each do |attr|
          add_column(table, attr, model_class)
        end
      end

      def add_column(table, attr, model_class)
        column_name = model_class.human_attribute_name(attr)

        table.column(column_name) do |item|
          if attr == "id"
            id_link(item)
          else
            format_value(item.public_send(attr))
          end
        end
      end

      def add_column(table, attr, model_class)
        column_name = model_class.human_attribute_name(attr)

        table.column(column_name) do |item|
          if attr == "id"
            id_link(item)
          else
            value = item.public_send(attr)

            # Verifica se é uma associação
            association = model_class.reflect_on_association(attr.remove("_id").to_sym)
            if association
              format_association(value, association)
            else
              format_value(value)
            end
          end
        end
      end

      def format_association(value, association)
        return nil if value.nil?

        case association.macro
        when :belongs_to, :has_one
          # Busca o objeto relacionado e tenta exibir um atributo legível
          related_object = association.klass.find_by(id: value)
          return nil unless related_object

          related_object.try(:name) ||
          related_object.try(:title) ||
          related_object.try(:email) ||
          "#{association.klass.model_name.human} ##{related_object.id}"
        when :has_many, :has_and_belongs_to_many
          "#{value.count} #{association.klass.model_name.human(count: value.count)}"
        end
      end

      def format_value(value)
        case value
        when Time, DateTime, ActiveSupport::TimeWithZone
          I18n.l(value, format: :short)
        when Date
          I18n.l(value, format: :short)
        else
          value
        end
      end

      def id_link(item)
        a(href: "/#{data.model_name.route_key}/#{item.id}") { item.id }
      end
    end
  end
end
