# -*- encoding : utf-8 -*-
module FlexibleDate
  module Base
    def flexible_date(*params)
      params.last.kind_of?(Hash) ? (options, fields = params.pop, params) : (options, fields = {}, params)
      suffix = options[:suffix] || "flex"
      condition = options[:if]

      fields.each do |field|
        unless methods.include?(:flexible_date_validations)
          validate :flexible_date_validations

          define_method :flexible_date_validations do
            if @flexible_date_errors
              @flexible_date_errors.each do |field, message|
                errors.add(field, message)
              end
            end
          end
        end

        field_with_suffix = "#{field}_#{suffix}"
        attr_accessible field_with_suffix

        define_method "#{field_with_suffix}" do
          if self.class.columns_hash[field.to_s].type == :datetime
            format = I18n.t("flexible_date.configuration.datetime_format")
          else
            format = I18n.t("flexible_date.configuration.format")
          end
          date = self.send("#{field}")
          date.try(:strftime, format)
        end

        define_method "#{field_with_suffix}=" do |value|
          try_t = lambda do |option1, option2|
            begin
              I18n.t option1, :raise => true
            rescue I18n::MissingTranslationData
              I18n.t option2
            end
          end

          @flexible_date_errors ||= {}
          if condition and not condition.call(self)
            @flexible_date_errors["#{field}".to_sym] = try_t.call(
              "flexible_date.messages.without_suffix.invalid",
              "flexible_date.messages.invalid")
            @flexible_date_errors["#{field_with_suffix}".to_sym] = try_t.call(
              "flexible_date.messages.with_suffix.invalid",
              "flexible_date.messages.invalid")
          else
            begin
              if self.class.columns_hash[field.to_s].type == :datetime
                class_name = DateTime
                format = I18n.t("flexible_date.configuration.datetime_format")
              else
                class_name = Date
                format = I18n.t("flexible_date.configuration.format")
              end
              self.send("#{field}=", value.blank? ? "" : class_name.strptime(value, format))
            rescue ArgumentError
              self.send("#{field}=", nil)
              @flexible_date_errors["#{field}".to_sym] = try_t.call(
                "flexible_date.messages.without_suffix.invalid",
                "flexible_date.messages.invalid")
              @flexible_date_errors["#{field_with_suffix}".to_sym] = try_t.call(
                "flexible_date.messages.with_suffix.invalid",
                "flexible_date.messages.invalid")
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend(FlexibleDate::Base)
