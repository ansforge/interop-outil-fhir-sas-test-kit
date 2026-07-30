require_relative '../single_practitioner_single_location_tests/ps_bundle_url_equal_url_test'

module SasTestKit
    module SingleAssociation
        class ValidateBundleLink < SinglePractitionerSingleLocation::BundleUrlEqualUrl
            id :sos_validate_bundle_link
        end
    end
end