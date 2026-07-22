require_relative 'visual_group'
require_relative 'capability_statement_group'
require_relative 'security/tls_test_suite'
require_relative 'aggregation/cpts_aggregation_group'
require_relative 'prise_de_rendez_vous/flux_v1_group'
require_relative 'prise_de_rendez_vous/flux_v2_group'
require_relative 'prise_de_rendez_vous/flux_v3_group'

require_relative 'sas_options'
require_relative 'common_suite'

module SasTestKit
    class CPTSSuite < Suite
        id :cpts
        title 'Sas Test Kit Test Suite - CPTS'

        group from: :tls,
            config: {
                options: {
                    launch_version: SASOptions::IG_VERSION_CPTS
                }
            }

        group from: :visual_group

        group from: :capability_statement

        group from: :cpts_aggregation_group,
            config: {
                options: {
                    launch_version: SASOptions::IG_VERSION_CPTS
                }
            }
        
        group from: :flux_v1_group

        group from: :flux_v2_group,
            config: {
                options: {
                    launch_version: SASOptions::IG_VERSION_CPTS
                }
            }

        group from: :flux_v3_group
    end
end
