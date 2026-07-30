require_relative '../single_practitioner_single_location_tests/ps_validate_slots_status_test'

module SasTestKit
    module SingleAssociation
        class ValidateStatus < SinglePractitionerSingleLocation::ValidateStatus
            id :sos_validate_slots_status
        end
    end
end