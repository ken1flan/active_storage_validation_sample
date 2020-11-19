RSpec::Matchers.define :validate_attached_file_number_of do |attr_name|
  match do |obj|
    obj.class.validators.find do |v|
      v.instance_of?(AttachedFileNumberValidator) && v.attributes.include?(attr_name)
    end
  end
end
