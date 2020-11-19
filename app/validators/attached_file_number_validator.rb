class AttachedFileNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true unless value.attached?

    file_number = value.size

    if (limit = options[:maximum]).present? && file_number > limit
      record.errors.add(attribute, :too_many_files, count: limit)
    end
    if (limit = options[:minimum]).present? && file_number < limit
      record.errors.add(attribute, :too_few_files, count: limit)
    end
  end
end
