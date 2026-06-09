module SasTestKit
  class MTLSGroup < Inferno::TestGroup
    title 'Tests connexion MTLS'
    description %(
      ## Description

      Ce groupe de tests a pour objectif de vérifier la mise en œuvre de la connexion sécurisée par **authentification mutuelle TLS (mTLS)** entre un client (plateforme SAS) et un serveur FHIR.

      Les tests valident le comportement du serveur lorsqu'il est sollicité avec différents types de certificats clients, afin de s'assurer que les règles de sécurité attendues sont correctement appliquées selon la [spécification](https://esante.gouv.fr/sites/default/files/media/document/SAS_SPEC_Securisation-des-echanges-par-mTLS_20240524_V3.2.pdf).

      Le groupe de test couvre notamment les cas suivants :
      - utilisation d'un certificat client valide,
      - utilisation de certificats invalides (CNAME incorrect, OU incorrect),
      - utilisation d'un certificat révoqué,
      - absence de certificat client.

      Pour chaque configuration, une requête fonctionnelle est envoyée vers l'endpoint FHIR, et le comportement du serveur est évalué à partir de la réponse ou de l'erreur retournée.

      L'objectif de ces tests est de garantir que :
      - les connexions mTLS valides sont acceptées,
      - les connexions non conformes ou non sécurisées sont correctement rejetées.
    )
    id :mtls_group
    verifies_requirements 'agg-psindiv@1', 'agg-psindiv@2', 'agg-psindiv@3', 'agg-psindiv@4', 'agg-psindiv@6', 'agg-psindiv@7'

    def build_params(launch_version)
      if launch_version == 'ig_launch_1'
        {
          _include: 'Slot:schedule',
          '_include:iterate': 'Schedule:actor',
          status: 'free',
          start: [
            "ge2024-01-01T00:00:00.000+00:00",
            "le2024-01-03T23:59:59.999+00:00"
          ],
          'schedule.actor:Practitioner.identifier':
            'urn:oid:1.2.250.1.71.4.2.1|810101215225'
        }
      else
        {
          _include: ['Slot:schedule', 'Slot:service-type-reference'],
          '_include:iterate': ['Schedule:actor', 'HealthcareService:organization'],
          status: 'free',
          start: [
            "ge2024-06-12T16:20:00.000+02:00",
            "le2024-06-15T16:20:00.000+02:00"
          ],
          'schedule.actor:Practitioner.identifier':
            'urn:oid:1.2.250.1.71.4.2.1|810002909371,urn:oid:1.2.250.1.71.4.2.1|810001288385'
        }
      end
    end

    def resolve_client(mtls_enabled, fallback: :default, no_mTLS: :no_mTLS)
      mtls_enabled == 'true' ? fallback : no_mTLS
    end

     test do
      title 'Test certificat valide'
      description %(
         mTLS certificat valide
      )
      
      run do
        begin
          params = build_params(suite_options[:launch_version])
          client = resolve_client(mTLS)

          fhir_search('Slot', params: params, client: client)
        rescue OpenSSL::SSL::SSLError => e
          add_message('info', "[INFO][#{e.class}] : #{e.message}")
          assert(1 < 0)
        rescue StandardError => e
          add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
          assert(1 < 0, 'Une erreur a eu lieu lors du parsing de la réponse')
        end

        assert(response[:status] == 200, "Expected status to be 200, got #{response[:status]}") unless response.nil?
      end
    end
    
    test do
      title 'Test certificat mauvais cname'
      description %(
         mTLS erreur cname
      )
      verifies_requirements 'agg-psindiv@2'
     
      fhir_client do
        url :base_url
        ssl_client_cert OpenSSL::X509::Certificate.new(File.read("#{ENV["CERT_PATH"]}/invalid_bad_cname_certificate.key.crt.ca.pem"))
        ssl_client_key OpenSSL::PKey::RSA.new(File.read("#{ENV["CERT_PATH"]}/invalid_bad_cname.key"))
        verify_ssl OpenSSL::SSL::VERIFY_PEER
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end

      run do
        begin
          params = build_params(suite_options[:launch_version])
          client = resolve_client(mTLS)

          fhir_search('Slot', params: params, client: client)
        rescue OpenSSL::SSL::SSLError => e
          add_message('info', "[INFO][#{e.class}] : #{e.message}")
          assert(1 > 0)
        rescue StandardError => e
          add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
          assert(1 < 0, 'Une erreur a eu lieu lors du parsing de la réponse')
        end

        assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}") unless response.nil?
      end
    end

     test do
      title 'Test certificat mauvais OU'
      description %(
         mTLS erreur OU
      )
      verifies_requirements 'agg-psindiv@3'

      fhir_client do
        url :base_url
        ssl_client_cert OpenSSL::X509::Certificate.new(File.read("#{ENV["CERT_PATH"]}/invalid_bad_ou_certificate.key.crt.ca.pem"))
        ssl_client_key OpenSSL::PKey::RSA.new(File.read("#{ENV["CERT_PATH"]}/invalid_bad_ou.key"))
        verify_ssl OpenSSL::SSL::VERIFY_PEER
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end

      run do
        begin
          params = build_params(suite_options[:launch_version])
          client = resolve_client(mTLS)

          fhir_search('Slot', params: params, client: client)
        rescue OpenSSL::SSL::SSLError => e
          add_message('info', "[INFO][#{e.class}] : #{e.message}")
          assert(1 > 0)
        rescue StandardError => e
          add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
          assert(1 < 0, 'Une erreur a eu lieu lors du parsing de la réponse')
        end

        assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}") unless response.nil?
      end
    end

    test do
      title 'Test certificat revoqué'
      description %(
         test mTLS certificat revoqué
      )

      fhir_client do
        url :base_url
        ssl_client_cert OpenSSL::X509::Certificate.new(File.read("#{ENV["CERT_PATH"]}/invalid_revoked_certificate.key.crt.ca.pem"))
        ssl_client_key OpenSSL::PKey::RSA.new(File.read("#{ENV["CERT_PATH"]}/invalid_revoked_certificate.key"))
        verify_ssl OpenSSL::SSL::VERIFY_PEER

        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end

      run do
        begin
          params = build_params(suite_options[:launch_version])
          client = resolve_client(mTLS)

          fhir_search('Slot', params: params, client: client)
        rescue OpenSSL::SSL::SSLError => e
          add_message('info', "[INFO][#{e.class}] : #{e.message}")
          assert(1 > 0)
        rescue StandardError => e
          add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
          assert(1 < 0, 'Une erreur a eu lieu lors du parsing de la réponse')
        end

        assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}") unless response.nil?
      end
    end

    test do
      title 'Test sans certificat'
      description %(
         pas de certificat
      )

      fhir_client :no_certificate_mTLS do
        url :base_url
        verify_ssl OpenSSL::SSL::VERIFY_PEER
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end   
     
      fhir_client :no_certificate_no_mTLS do
        url :base_url
        verify_ssl OpenSSL::SSL::VERIFY_NONE
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end

      run do
        begin
          params = build_params(suite_options[:launch_version])
          client = resolve_client(mTLS, fallback: :no_certificate_mTLS, no_mTLS: :no_certificate_no_mTLS)

          fhir_search('Slot', params: params, client: client)
        rescue OpenSSL::SSL::SSLError => e
          add_message('info', "[INFO][#{e.class}] : #{e.message}")
          assert(1 > 0)
        rescue StandardError => e
          add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
          assert(1 < 0, 'Une erreur a eu lieu lors du parsing de la réponse')
        end

        assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}") unless response.nil?
      end
    end
  end
end