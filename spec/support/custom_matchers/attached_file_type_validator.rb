RSpec::Matchers.define :validate_attached_file_type_of do |attr_name|
  match do |obj|
    obj._validators[attr_name].find { |i| i.instance_of?(AttachedFileTypeValidator) }
  end
end
