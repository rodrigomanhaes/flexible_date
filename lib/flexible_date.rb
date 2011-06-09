# -*- encoding : utf-8 -*-
module FlexibleDate
  def flexible_date(*params)
    params.last.kind_of?(Hash) ? (options, fields = params.pop, params) : (options, fields = {}, params)
    suffix = options[:suffix] || "flex"
    condition = options[:if]
    blank_data = options[:blank].nil? ? false : options[:blank]

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

      define_method "#{field}_#{suffix}" do
        format = I18n.t("flexible_date.configuration.format")
        date = self.send("#{field}")
        date.try(:strftime, format)
      end

      define_method "#{field}_#{suffix}=" do |value|
        try_t = lambda do |option1, option2|
          begin
            I18n.t option1, :raise => true
          rescue I18n::MissingTranslationData
            I18n.t option2
          end
        end

        @flexible_date_errors ||= {}
        if not condition.nil? and not condition.call(self)
          @flexible_date_errors["#{field}".to_sym] = try_t.call(
            "flexible_date.messages.without_suffix.invalid",
            "flexible_date.messages.invalid")
          @flexible_date_errors["#{field}_#{suffix}".to_sym] = try_t.call(
            "flexible_date.messages.with_suffix.invalid",
            "flexible_date.messages.invalid")
        elsif value.blank? and not blank_data
          @flexible_date_errors["#{field}".to_sym] = try_t.call(
            "flexible_date.messages.without_suffix.empty",
            "flexible_date.messages.empty")
          @flexible_date_errors["#{field}_#{suffix}".to_sym] = try_t.call(
            "flexible_date.messages.with_suffix.empty",
            "flexible_date.messages.empty")
        else
          begin
            format = I18n.t("flexible_date.configuration.format")
            self.send("#{field}=", Date.strptime(value, format))
          rescue ArgumentError
            self.send("#{field}=", nil)
            if not blank_data
              @flexible_date_errors["#{field}".to_sym] = try_t.call(
                "flexible_date.messages.without_suffix.invalid",
                "flexible_date.messages.invalid")
              @flexible_date_errors["#{field}_#{suffix}".to_sym] = try_t.call(
                "flexible_date.messages.with_suffix.invalid",
                "flexible_date.messages.invalid")
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend(FlexibleDate)

