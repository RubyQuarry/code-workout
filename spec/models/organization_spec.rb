# == Schema Information
#
# Table name: organizations
#
#  id           :integer          not null, primary key
#  display_name :string(255)      not null
#  url_part     :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_organizations_on_display_name  (display_name) UNIQUE
#  index_organizations_on_url_part      (url_part) UNIQUE
#

require 'spec_helper'

describe Organization do
  pending "add some examples to (or delete) #{__FILE__}"
end
