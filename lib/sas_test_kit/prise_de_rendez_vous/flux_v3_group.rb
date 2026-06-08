require_relative 'v3_validate_appointment_test'

module SasTestKit
    class FluxV3Group < Inferno::TestGroup
        title "Remontée des informations de rendez-vous - Flux V3"
        description %()
        id :flux_v3_group

        test from: :v3_validate_appointment
    end
end