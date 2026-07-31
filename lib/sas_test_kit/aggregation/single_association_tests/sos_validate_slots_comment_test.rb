require_relative '../single_practitioner_single_location_tests/ps_slot_has_url_test'

module SasTestKit
    module SingleAssociation
        class ValidateSlotsComment < SinglePractitionerSingleLocation::SlotHasUrl
            id :sos_validate_slots_comment
        end
    end
end