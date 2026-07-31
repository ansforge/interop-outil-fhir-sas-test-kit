require_relative 'metadata'
require_relative 'visual_group'
require_relative 'capability_statement_group'
require_relative 'security/tls_test_suite'
require_relative 'aggregation/ps_aggregation_group'
require_relative 'prise_de_rendez_vous/flux_v1_group'
require_relative 'prise_de_rendez_vous/flux_v2_group'
require_relative 'prise_de_rendez_vous/flux_v3_group'
require_relative 'sas_options'

require_relative 'common_suite'

module SasTestKit
  class PSSuite < Suite
    id :sas
    title 'Sas Test Kit Test Suite - PS à titre individuel'

    group from: :tls,
        config: {
            options: {
                launch_version: SASOptions::IG_VERSION_PSINDIV
            }
        }

    group from: :visual_group

    group from: :capability_statement

    group from: :ps_aggregation_group,
        config: {
            options: {
                launch_version: SASOptions::IG_VERSION_PSINDIV
            }
        }
    
    group from: :flux_v1_group

    group from: :flux_v2_group,
        config: {
            options: {
                launch_version: SASOptions::IG_VERSION_PSINDIV
            }
        }

    group from: :flux_v3_group
  end
end 