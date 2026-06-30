require_relative 'flux_v3_tests/v3_validate_appointment_test'
require_relative 'flux_v3_tests/v3_validate_rpps_test'
require_relative 'flux_v3_tests/v3_validate_code_test'
require_relative 'flux_v3_tests/v3_validate_url_test'
require_relative 'flux_v3_tests/v3_validate_status_test'

module SasTestKit
    module FluxV3Group
        class FluxV3Group < Inferno::TestGroup
            title "Remontée des informations de rendez-vous - Flux V3"
            description %()
            id :flux_v3_group

            test from: :v3_validate_appointment

            test from: :v3_validate_rpps

            test from: :v3_validate_code

            test from: :v3_validate_url

            test from: :v3_validate_status
        end
    end
end