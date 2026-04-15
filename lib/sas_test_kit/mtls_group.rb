module SasTestKit
  class MTLSGroup < Inferno::TestGroup
    title 'Tests connexion MTLS'
    description %(
      ## Description

      Ce groupe de tests a pour objectif de vérifier la mise en œuvre de la connexion sécurisée par **authentification mutuelle TLS (mTLS)** entre un client et un serveur FHIR SAS.

      Les tests valident le comportement du serveur lorsqu'il est sollicité avec différents types de certificats clients, afin de s'assurer que les règles de sécurité attendues sont correctement appliquées.

      Le test group couvre notamment les cas suivants :
      - utilisation d'un certificat client valide,
      - utilisation de certificats invalides (CNAME incorrect, OU incorrect),
      - utilisation d'un certificat révoqué,
      - absence de certificat client.

      Pour chaque configuration, une requête fonctionnelle est envoyée vers l'API FHIR, et le comportement du serveur est évalué à partir de la réponse ou de l'erreur retournée.

      L'objectif de ces tests est de garantir que :
      - les connexions mTLS valides sont acceptées,
      - les connexions non conformes ou non sécurisées sont correctement rejetées.
    )
    id :mtls_group

     test do
      title 'Test certificat valide'
      description %(
         mTLS certificat valide
      )
     

      fhir_client do
        url :base_url
        ssl_client_cert OpenSSL::X509::Certificate.new(File.read("./config/cert/inferno-prePROD.pem"))
        ssl_client_key OpenSSL::PKey::RSA.new(File.read("./config/cert/inferno-prePROD.key"))
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end   

      run do

        if suite_options[:launch_version] == 'ig_launch_1'

          begin
            if mTLS == 'true'
                fhir_search('Slot', params: { _include: 'Slot:schedule', 
                '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
                })
            else
                fhir_search('Slot', params: { _include: 'Slot:schedule', 
                '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
                }, client: :no_mTLS)
            end
            
          rescue StandardError => e
            add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
          end


        elsif suite_options[:launch_version] == 'ig_launch_2'
       
          fhir_search('Slot', params: {
          _include: [
          'Slot:schedule',
          'Slot:service-type-reference'
            ],
            '_include:iterate': [
              'Schedule:actor',
              'HealthcareService:organization'
            ],
          status: 'free',
          start: [
          "ge2024-06-12T16:20:00.000+02:00",
          "le2024-06-15T16:20:00.000+02:00"
          ],
          'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810002909371,urn:oid:1.2.250.1.71.4.2.1|810001288385'
          })

        end
        if response.nil?
          assert(1<0, "Response is nil")
        else
          assert_response_status(200)
        end
      end
    end
    
    test do
      title 'Test certificat mauvais cname'
      description %(
         mTLS erreur cname
      )
     

      fhir_client do
        url :base_url
        ssl_client_cert OpenSSL::X509::Certificate.new(File.read("./config/cert/invalid_bad_cname_certificate.key.crt.ca.pem"))
        ssl_client_key OpenSSL::PKey::RSA.new(File.read("./config/cert/invalid_bad_cname.key"))
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end   

      run do
        
         if suite_options[:launch_version] == 'ig_launch_1'
            begin
                if mTLS == 'true'
                    fhir_search('Slot', params: { _include: 'Slot:schedule', 
                    '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                    'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
                    })
                else
                    fhir_search('Slot', params: { _include: 'Slot:schedule', 
                    '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                    'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
                    }, client: :no_mTLS)
                end
            rescue OpenSSL::SSL::SSLError => e
                add_message('info', "[INFO][#{e.class}] : #{e.message}")
                assert(1 > 0)
            rescue StandardError => e
                add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
                assert(1 < 0, 'Response is nil')
            end
      
        elsif suite_options[:launch_version] == 'ig_launch_2'

          fhir_search('Slot', params: {
            _include: [
            'Slot:schedule',
            'Slot:service-type-reference'
              ],
              '_include:iterate': [
                'Schedule:actor',
                'HealthcareService:organization'
              ],
            status: 'free',
            start: [
            "ge2024-06-12T16:20:00.000+02:00",
            "le2024-06-15T16:20:00.000+02:00"
            ],
            'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810002909371,urn:oid:1.2.250.1.71.4.2.1|810001288385'
          })
        end

        if !response.nil?
          assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}")
        end
      end
    end

     test do
      title 'Test certificat mauvais OU'
      description %(
         mTLS erreur OU
      )
     

      fhir_client do
        url :base_url
        ssl_client_cert OpenSSL::X509::Certificate.new(File.read("./config/cert/invalid_bad_ou_certificate.key.crt.ca.pem"))
        ssl_client_key OpenSSL::PKey::RSA.new(File.read("./config/cert/invalid_bad_ou.key"))
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end   

      run do
        
        if suite_options[:launch_version] == 'ig_launch_1'
          begin
            if mTLS == 'true'
                fhir_search('Slot', params: { _include: 'Slot:schedule', 
                '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
                })
            else
                fhir_search('Slot', params: { _include: 'Slot:schedule', 
                '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
                }, client: :no_mTLS)
            end
          rescue OpenSSL::SSL::SSLError => e
            add_message('info', "[INFO][#{e.class}] : #{e.message}")
            assert(1 > 0)
          rescue StandardError => e
            add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
            assert(1 < 0, 'Response is nil')
          end
        elsif suite_options[:launch_version] == 'ig_launch_2'
         fhir_search('Slot', params: {
          _include: [
          'Slot:schedule',
          'Slot:service-type-reference'
            ],
            '_include:iterate': [
              'Schedule:actor',
              'HealthcareService:organization'
            ],
          status: 'free',
          start: [
          "ge2024-06-12T16:20:00.000+02:00",
          "le2024-06-15T16:20:00.000+02:00"
          ],
          'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810002909371,urn:oid:1.2.250.1.71.4.2.1|810001288385'
          })
        end

        if !response.nil?
          assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}")
        end
      end
    end

    test do
      title 'Test certificat revoqué'
      description %(
         test mTLS certificat revoqué
      )
     

      fhir_client do
        url :base_url
        ssl_client_cert OpenSSL::X509::Certificate.new(File.read("./config/cert/invalid_revoked_certificate.key.crt.ca.pem"))
        ssl_client_key OpenSSL::PKey::RSA.new(File.read("./config/cert/invalid_revoked_certificate.key"))
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end

      run do
        
        if suite_options[:launch_version] == 'ig_launch_1'
          begin
            if mTLS == 'true'
                fhir_search('Slot', params: { _include: 'Slot:schedule', 
                '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
                })
            else
                fhir_search('Slot', params: { _include: 'Slot:schedule', 
                '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
                }, client: :no_mTLS)
            end
          rescue OpenSSL::SSL::SSLError => e
            add_message('info', "[INFO][#{e.class}] : #{e.message}")
            assert(1 > 0)
          rescue StandardError => e
            add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
            assert(1 < 0, 'Response is nil')
          end
        elsif suite_options[:launch_version] == 'ig_launch_2'

          fhir_search('Slot', params: {
          _include: [
          'Slot:schedule',
          'Slot:service-type-reference'
            ],
            '_include:iterate': [
              'Schedule:actor',
              'HealthcareService:organization'
            ],
          status: 'free',
          start: [
          "ge2024-06-12T16:20:00.000+02:00",
          "le2024-06-15T16:20:00.000+02:00"
          ],
          'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810002909371,urn:oid:1.2.250.1.71.4.2.1|810001288385'
        })
        end

        if !response.nil?
          assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}")
        end
      end
    end

    test do
      title 'Test sans certificat'
      description %(
         pas de certificat
      )

      fhir_client :no_certificate do
        url :base_url
        headers(
        'Content-Type' => 'application/json',
        'Accept'  => 'application/json+fhir'
        )
      end   
     
      run do
        if suite_options[:launch_version] == 'ig_launch_1'
          begin
            fhir_search('Slot', params: { _include: 'Slot:schedule', 
                '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
                'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
              }, client: :no_certificate)
          rescue OpenSSL::SSL::SSLError => e
            add_message('info', "[INFO][#{e.class}] : #{e.message}")
            assert(1 > 0)
          rescue StandardError => e
            add_message('error', "[ERREUR][#{e.class}] : #{e.message}")
            assert(1 < 0, 'Response is nil')
          end
            
        elsif suite_options[:launch_version] == 'ig_launch_1'

          fhir_search('Slot', params: {
          _include: [
          'Slot:schedule',
          'Slot:service-type-reference'
            ],
            '_include:iterate': [
              'Schedule:actor',
              'HealthcareService:organization'
            ],
          status: 'free',
          start: [
          "ge2024-06-12T16:20:00.000+02:00",
          "le2024-06-15T16:20:00.000+02:00"
          ],
          'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810002909371,urn:oid:1.2.250.1.71.4.2.1|810001288385'
        }, client: :no_certificate)

        end
        if !response.nil?
          assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}")
        end
      end
    end
  end
end
