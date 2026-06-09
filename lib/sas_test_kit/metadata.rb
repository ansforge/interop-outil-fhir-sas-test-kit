require_relative 'sas_certification_suite'
require_relative 'ext/http_client_patch'

Inferno::DSL::HTTPClientBuilder.prepend(HTTPClientBuilderMTLSPatch)

module SasTestKit
  class Metadata < Inferno::TestKit
    id :sas_test_kit
    title "SAS - Service d'Accès aux Soins"
    description <<~DESCRIPTION
        Ce kit de test permet de valider la conformité de l'interfaçage avec la plateforme numérique du SAS, selon les [spécifications](https://interop.esante.gouv.fr/ig/fhir/sas/index.html). 
        ## Statut
        Ce test  kit couvre les flux suivant :
         - **agrégation de créneaux**
         - **gestion des comptes régulateurs**
         - **flux SSO**
         - transmission des informations de rendez-vous (**à venir**)

        Les cas d'usages suivants sont couverts :
        - **PS Indiv**
        - **CPTS**
        
        ## Depôt
        Le dépôt de ce test kit est disponible [ici](https://github.com/ansforge/interop-outil-fhir-sas-test-kit).
    DESCRIPTION
    suite_ids ['sas']
    tags ['sas']
    last_updated '2026-06-09'
    version '0.3.0'
    maturity 'Low'
    authors ['ANS']
    repo 'https://github.com/ansforge/interop-outil-fhir-sas-test-kit'
  end
end
