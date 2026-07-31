module SasTestKit
    class Suite < Inferno::TestSuite
        id :common_suite
        description %(
            Cette suite de test permet de valider la conformité de l'interfaçage avec la plateforme numérique du SAS, selon les [spécifications](https://interop.esante.gouv.fr/ig/fhir/sas/index.html). 
            Les flux testé sont les suivants :
            - agrégation de créneaux
            - gestion des comptes régulateurs
            - flux SSO
            - transmission des infos de rendez-vous
        )

        suite_summary %(
        Test de conformité aux spécifications SAS
        )

        links [
        {
        type: 'IG_SAS',
        label: 'IG SAS',
        url: 'https://ansforge.github.io/IG-fhir-service-acces-aux-soins/main/ig/'
        },
        {
            type: 'Github issue',
            label: 'Report Issue',
            url: 'https://github.com/ansforge/interop-outil-fhir-sas-test-kit/issues'
        }
        ]

        input_order :base_url, :mTLS

        input_instructions %(
            Afin de lancer les tests vous devez compléter l'ensemble des éléments.
        )

        # These inputs will be available to all tests in this suite
    
        input :base_url,
            title: 'URl du serveur',
            description: 'Url de base serveur FHIR'

        input :mTLS,
            title: 'Vérification mTLS',
            type: 'radio',
            default: 'true',
            options: {
                list_options: [
                { label: 'Activé', value: "true" },
                { label: 'Désactivé', value: "false" }
                ]
            }

        # All FHIR requests in this suite will use this FHIR client
        fhir_client :no_mTLS do
            url :base_url
            ssl_client_cert nil
            ssl_client_key nil
            verify_ssl OpenSSL::SSL::VERIFY_NONE
            headers(
                'Content-Type' => 'application/json',
                'Accept'  => 'application/json+fhir'
            )
        end
        
        fhir_client do
            url :base_url
            ssl_client_cert OpenSSL::X509::Certificate.new(File.read("#{ENV["CERT_PATH"]}/inferno-prePROD.pem")) 
            ssl_client_key OpenSSL::PKey::RSA.new(File.read("#{ENV["CERT_PATH"]}/inferno-prePROD.key"))
            verify_ssl OpenSSL::SSL::VERIFY_PEER
            headers(
                'Content-Type' => 'application/json',
                'Accept'  => 'application/json+fhir'
            )
            #oauth_credentials :credentials
        end

        # All FHIR validation requests will use this FHIR validator
        fhir_resource_validator :validator_sas do
            #igs 'ans.fhir.fr.sas#1.2.0' # Use this method for published IGs/versions
            igs 'igs/sas_package.tgz'   # Use this otherwise

            exclude_message do |message|
                message.message.match?(/\A\S+: \S+: URL value '.*' does not resolve/) ||
                message.message.include?(".specialty[0]: No code provided, and a code is required from the value set 'fr-practitioner-specialty'") ## Problème IG
            end
        end
    end
end