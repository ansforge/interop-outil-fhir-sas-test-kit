require_relative 'setup_test'
require_relative '../sas_options.rb'

require_relative 'single_practitioner_single_location_tests/cpts_validate_id_test'
require_relative 'single_practitioner_single_location_tests/cpts_validate_cardinality_test'
require_relative 'single_practitioner_single_location_tests/cpts_validate_ref_test'

module SasTestKit
  module SinglePractitionerSingleLocation
    class CPTSSinglePractitionerSingleLocation < SinglePractitionerSingleLocation
      id :cpts_single_practitioner_single_location

      test from: :validate_cardinality_cpts

      test from: :validate_ref_cpts

      test from: :validate_cpts_id
    end
  end
end
