# == Schema Information
#
# Table name: course_offerings
#
#  id                      :integer          not null, primary key
#  course_id               :integer          not null
#  term_id                 :integer          not null
#  name                    :string(255)      not null
#  label                   :string(255)
#  url                     :string(255)
#  self_enrollment_allowed :boolean
#  created_at              :datetime
#  updated_at              :datetime
#
# Indexes
#
#  index_course_offerings_on_course_id  (course_id)
#  index_course_offerings_on_term_id    (term_id)
#

require 'spec_helper'

describe CourseOffering do
  pending "add some examples to (or delete) #{__FILE__}"
end
