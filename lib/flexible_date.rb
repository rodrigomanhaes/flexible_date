# -*- encoding : utf-8 -*-
module FlexibleDate
  def flexible_date(*params)
    options, fields = params.pop, params
    format = options[:format]
    suffix = options[:suffix] || "flex"
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
        date = self.send("#{field}")
        date.try(:strftime, format)
      end

      define_method "#{field}_#{suffix}=" do |value|
        @flexible_date_errors ||= {}
        if value.blank?
          @flexible_date_errors["#{field}".to_sym] = I18n.t("flexible_date.messages.without_suffix.empty")
          @flexible_date_errors["#{field}_#{suffix}".to_sym] = I18n.t("flexible_date.messages.with_suffix.empty")
        else
          begin
            self.send("#{field}=", Date.strptime(value, format))
          rescue ArgumentError
            self.send("#{field}=", nil)
            @flexible_date_errors["#{field}".to_sym] = I18n.t("flexible_date.messages.without_suffix.invalid")
            @flexible_date_errors["#{field}_#{suffix}".to_sym] = I18n.t("flexible_date.messages.with_suffix.invalid")
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend(FlexibleDate)

