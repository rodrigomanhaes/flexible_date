module FlexibleDate
  def flexible_date(*params)
    options, fields = params.pop, params
    format = options[:format]
    fields.each do |field|
      validate :flexible_date_validations

      define_method "#{field}_flex" do
        date = self.send("#{field}")
        date.try(:strftime, format)
      end

      define_method "#{field}_flex=" do |value|
        begin
          self.send("#{field}=", Date.strptime(value, format))
        rescue ArgumentError
          self.send("#{field}=", nil)
          @flexible_date_errors ||= {}
          @flexible_date_errors["#{field}".to_sym] = 'invalid'
          @flexible_date_errors["#{field}_flex".to_sym] = 'invalid'
        end
      end

      define_method :flexible_date_validations do
        if @flexible_date_errors
          @flexible_date_errors.each do |field, message|
            errors.add(field, message)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend(FlexibleDate)

