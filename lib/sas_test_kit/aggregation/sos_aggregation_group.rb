require_relative 'sos_single_association_group'

module SasTestKit
    module SOSAggregationGroup
        class SOSAggregationGroup < Inferno::TestGroup
            title 'Flux agregateur'
            id    :sos_aggregation_group
            description %(
               )

            input_order :base_url, :mTLS

            group from: :single_association,
                config: {
                    options: {
                        launch_version: SASOptions::IG_VERSION_SOS
                    }
                }

        end
    end
end