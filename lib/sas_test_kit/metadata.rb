require_relative 'version'

module SasTestKit
  class Metadata < Inferno::TestKit
    id :sas
    title 'Sas Test Kit'
    description <<~DESCRIPTION
      This is a big markdown description of the test kit.
    DESCRIPTION
    suite_ids [:sas]
    version VERSION
    maturity 'Low'
    authors ["ans"]
    # repo 'TODO'
  end
end
