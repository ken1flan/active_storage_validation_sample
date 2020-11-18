class AttachedFilePresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :blank) unless value.attached?
  end
end
