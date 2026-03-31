require_relative '../aggregation/setup_test'
require_relative '../sas_options'
require_relative 'v2_connexion_without_origin_test'

require 'nokogiri'

module SasTestKit
    class FluxV2Group < Inferno::TestGroup
        title "Tests de conformité SAS - Flux V2 (SSO)"
        description %()
        id :flux_v2_group

        http_client do
            url ''
        end

        test from: :slot_search_setup do
            config(
                inputs: { 
                practitioner_id: { name: :practitioner_id },
                }
            )
        end

        test from: :sso_without_origin
    end
end