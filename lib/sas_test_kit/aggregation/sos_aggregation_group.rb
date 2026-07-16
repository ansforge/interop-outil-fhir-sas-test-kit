require_relative 'single_pfg_single_location_group'

module SasTestKit
    module SOSAggregationGroup
        class SOSAggregationGroup < Inferno::TestGroup
            title 'Flux agregateur'
            id    :sos_aggregation_group
            short_id 4
            description %(
               )

            input_order :base_url, :mTLS

            group from: :single_pfg_single_location

        end
    end
end