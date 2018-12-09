class ApplicationService
  include ActiveModel::Validations
  def merge_errors_from(object, prefix=nil, default_errors=nil)
    _gather_errors(object.errors.messages, prefix) unless object.errors.blank?
    _gather_errors(default_errors, prefix) if default_errors && errors.blank?
    false
  end

  def _gather_errors(messages, prefix)
    messages = { base: Array(messages).flatten.compact } unless messages.kind_of?(Hash)
    messages.each do |f, errs|
      f = prefix ? :"#{prefix}[#{f}]" : f
      errs.each { |err| self.errors.add(f, err) }
    end
  end
end