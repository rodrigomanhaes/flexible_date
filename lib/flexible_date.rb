module FlexibleDate
  def flexible_date(*params)
    options, fields = params.pop, params
    fields.each {|f| attr_accessor "#{f}_flex".to_sym }
  end
end

ActiveRecord::Base.extend(FlexibleDate)

