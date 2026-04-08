require_relative 'sas_certification_suite'

module SasTestKit
  class Metadata < Inferno::TestKit
    id :sas_test_kit
    title "SAS - Service d'Accès aux Soins"
    description <<~DESCRIPTION
        Ce test kit permet de valider la conformité
        aux spécifications du Service d'Accès aux Soins (SAS).
        ## Depôt
        Le dépôt de ce test kit est disponible [ici](https://github.com/ansforge/interop-outil-fhir-sas-test-kit).
    DESCRIPTION
    suite_ids ['sas']
    tags ['sas']
    last_updated '2026-04-08'
    version '0.1.0'
    maturity 'Low'
    authors ['ANS']
    repo 'https://github.com/ansforge/interop-outil-fhir-sas-test-kit'
  end
end
