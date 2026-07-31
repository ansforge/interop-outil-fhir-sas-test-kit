require_relative '../single_practitioner_single_location_tests/ps_validate_dates_test'

module SasTestKit
    module SingleAssociation
        class ValidateDates < SinglePractitionerSingleLocation::ValidateDates
            id :sos_validate_dates
        end
    end
end