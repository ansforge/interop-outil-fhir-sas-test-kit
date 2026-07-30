require_relative '../single_practitioner_single_location_tests/ps_validate_appointmentType_test'

module SasTestKit
    module SingleAssociation
        class ValidateAppointmentType < SinglePractitionerSingleLocation::ValidateAppointmentType
            id :sos_validate_slots_appointmentType
        end
    end
end