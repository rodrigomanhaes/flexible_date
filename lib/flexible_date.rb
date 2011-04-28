module FlexibleDate
  def flexible_date(*params)
    options, fields = params.pop, params
    format = options[:format]
    fields.each do |field|
      define_method "#{field}_flex=" do |value|
        self.send("#{field}=", Date.strptime(value, format))
      end
      define_method "#{field}_flex" do
        self.send("#{field}").strftime(format)
      end
    end
  end
end

ActiveRecord::Base.extend(FlexibleDate)

