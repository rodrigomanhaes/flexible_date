module FlexibleDate
  def flexible_date(*params)
    options, fields = params.pop, params
    format = options[:format]
    fields.each do |field|
      define_method "#{field}_flex=" do |value|
        self.send("#{field}=", Date.strptime(value, format))
      end
      attr_reader "#{field}_flex"
    end
  end
end

ActiveRecord::Base.extend(FlexibleDate)

