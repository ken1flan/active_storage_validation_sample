class AttachedFileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true unless value.attached?
    return true unless options&.dig(:maximum)

    maximum = options[:maximum]
    attachements = value.is_a?(ActiveStorage::Attached::Many) ? value.attachments : [value.attachment]
    if attachements.any? { |attachment| attachment.byte_size >= maximum }
      record.errors.add(attribute, :less_than, { count: maximum.to_s(:human_size) })
    end
  end
end
