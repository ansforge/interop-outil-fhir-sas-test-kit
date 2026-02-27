module SasTestKit
  module SASOptions

    AGGREGATION = 'aggregation'.freeze
    RENDEZ_VOUS = 'rendez_vous'.freeze
    ALL = 'all'.freeze

    IG_VERSION_PSINDIV = 'ig_launch_1'.freeze
    IG_VERSION_CPTS = 'ig_launch_2'.freeze

    TEST_REQUIREMENT_AGGREGATION = { type_de_tests: AGGREGATION }.freeze
    TEST_REQUIREMENT_RENDEZ_VOUS = { type_de_tests: RENDEZ_VOUS }.freeze
    TEST_REQUIREMENT_ALL = { type_de_tests: ALL }.freeze

    IG_REQUIREMENT_PSINDIV = { launch_version: IG_VERSION_PSINDIV }.freeze
    IG_REQUIREMENT_CPTS = { launch_version: IG_VERSION_CPTS }.freeze
  end
end