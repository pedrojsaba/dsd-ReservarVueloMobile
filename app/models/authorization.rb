class Authorization < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_or_create_from_hash(auth_hash)
    authorization = find_or_initialize_by_provider_and_uid(hash['provider'], hash['uid'])
    Rails.logger.info authorization.inspect
    if authorization.new_record?
      authorization.user = User.create(name: auth_hash["user_info"]["name"])
      authorization.save
    end
    authorization.user
  end

end

