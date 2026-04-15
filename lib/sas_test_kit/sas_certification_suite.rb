require_relative 'metadata'
require_relative 'visual_group'
require_relative 'tls_test_suite'
require_relative 'mtls_group'
require_relative 'IDNST_group_ps'
require_relative 'aggregation/aggregation_group'
require_relative 'prise_de_rendez_vous/flux_v1_group'
require_relative 'prise_de_rendez_vous/flux_v2_group'

require_relative 'sas_options'

module SasTestKit
  class Suite < Inferno::TestSuite
    id :sas
    title 'Sas Test Kit Test Suite'
    description %(
          #  Qu'est-ce que la plateforme numérique du SAS ?
          La plateforme numérique du service d'accès aux soins (SAS) est un outil dédié aux professionnels de la chaîne de régulation médicale pour faciliter l'orientation vers la médecine de ville. Simple et modulable, elle facilite l'accès à l'offre de soins disponible et s'intègre dans l'écosystème du numérique en santé.

          #  Développement et recette connectée
          Cette suite de test est mise à diposition pour faciliter la recette connectée
        )

    suite_summary %(
    Test de conformité aux spécifications SAS
    )

    suite_option :launch_version,
               title: 'Sélection version de l\'IG',
               list_options: [
                 {
                   label: 'IG version PS indiv',
                   value: SASOptions::IG_VERSION_PSINDIV
                 },
                 {
                   label: 'IG version CPTS',
                   value: SASOptions::IG_VERSION_CPTS
                 }
               ]

    links [
      {
      type: 'IG_SAS',
      label: 'IG SAS',
      url: 'https://ansforge.github.io/IG-fhir-service-acces-aux-soins/main/ig/'
      }
    ]

    input_order :base_url, :mTLS,:gestion_rpps, :gestion_rpps_notes, :gestion_rpps_obligatoire, :gestion_rpps_obligatoire_notes, :gestion_idnst,:gestion_idnst_notes,
            :practitioner_id, :practitioner_id2, :practitioner_id3, :practitioner_id4, :regulator_id

     input_instructions %(
        Afin de lancer les tests vous devez compléter l'ensemble des éléments.
      )

    # These inputs will be available to all tests in this suite
   
    input :base_url,
          title: 'URl du serveur',
          description: 'Url de base serveur FHIR'

    input :mTLS,
          title: 'mTLS',
          type: 'radio',
          options: {
            list_options: [
              { label: 'Activé', value: true },
              { label: 'Désactivé', value: false }
            ]
          }
    # All FHIR requests in this suite will use this FHIR client
          
    fhir_client :no_mTLS do
      url :base_url
      ssl_client_cert nil
      ssl_client_key nil
      headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
      )
    end
    
    fhir_client do
      url :base_url
      ssl_client_cert OpenSSL::X509::Certificate.new(File.read("./config/cert/inferno-prePROD.pem")) 
      ssl_client_key OpenSSL::PKey::RSA.new(File.read("./config/cert/inferno-prePROD.key"))
      headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
      )
      #oauth_credentials :credentials
    end

    # All FHIR validation requests will use this FHIR validator
    fhir_resource_validator :validator_sas do
       #igs 'ans.fhir.fr.sas#1.1.0' # Use this method for published IGs/versions
       igs 'igs/sas_package.tgz'   # Use this otherwise

      exclude_message do |message|
        message.message.match?(/\A\S+: \S+: URL value '.*' does not resolve/)
      end
    end
    group from: :tls
    group from: :visual_group     
    
    group do
  
      id :capability_statement
      title 'Capability Statement'
      description 'Verification de la présence du  CapabilityStatement sur le serveur'
      optional

      test do
        optional
        id :capability_statement_read
        title 'Recupération du  CapabilityStatement'
        description 'Récupération  du CapabilityStatement du endpoint  /metadata '

        run do
          fhir_get_capability_statement

          assert_response_status(200)
          assert_resource_type(:capability_statement) 
        end
      end
    end

    group from: :aggregation_group
    
    group from: :flux_v1_group

    group from: :flux_v2_group
  end
end 