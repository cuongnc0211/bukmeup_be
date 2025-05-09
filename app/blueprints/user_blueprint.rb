class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :email, :phone_number

  field :avatar_url do |user|
    if user.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        user.avatar.variant(:thumb), only_path: false
      )
    end
  end

  field :cover_url do |user|
    if user.cover.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        user.cover.variant(:thumb), only_path: false
      )
    end
  end
end
