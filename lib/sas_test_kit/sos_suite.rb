require_relative 'visual_group'
require_relative 'capability_statement_group'
require_relative 'security/tls_test_suite'
require_relative 'aggregation/sos_aggregation_group'
require_relative 'prise_de_rendez_vous/flux_v1_group'
require_relative 'prise_de_rendez_vous/flux_v2_group'
require_relative 'prise_de_rendez_vous/flux_v3_group'

require_relative 'sas_options'
require_relative 'common_suite'

module SasTestKit
    class SOSSuite < Suite
        id :sos
        title 'Sas Test Kit Test Suite - SOS'

        group from: :tls,
            config: {
                options: {
                    launch_version: SASOptions::IG_VERSION_SOS
                }
            }

        group from: :visual_group

        group from: :capability_statement

        group from: :sos_aggregation_group
        
        group from: :flux_v1_group

        group from: :flux_v2_group do
            config(
                options: {
                    launch_version: SASOptions::IG_VERSION_SOS
                }
            )
            replace :flux_v2_not_connected_group, :flux_v2_sos_not_connected_group
        end

        group from: :flux_v3_group
    end
end
