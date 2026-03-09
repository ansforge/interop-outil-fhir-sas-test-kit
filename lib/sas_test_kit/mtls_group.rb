module SasTestKit
  class MTLSGroup < Inferno::TestGroup
    title 'Test connexion MTLS'
    description 'Verification mTLS'
    id :mtls_group

     test do
      title 'Test certificat valide'
      description %(
         mTLS certificat valide
      )
     

      fhir_client do
      url :base_url
      headers 'Accept' => '*/*'
      ssl_client_cert OpenSSL::X509::Certificate.new(File.read("./config/cert/inferno-prePROD.pem")) 
      ssl_client_key OpenSSL::PKey::RSA.new(File.read("./config/cert/inferno-prePROD.key")) 
      end   

      run do

        if suite_options[:launch_version] == 'ig_launch_1'

          begin
            fhir_search('Slot', params: { _include: 'Slot:schedule', 
            '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
            'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
            })
          rescue
            add_message('error', "Request failed: #{request}")
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
      end   

      run do
        
         if suite_options[:launch_version] == 'ig_launch_1'
            begin
              fhir_search('Slot', params: { _include: 'Slot:schedule', 
              '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
              'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
              })
            rescue
              add_message('error', "Request failed: #{request}")
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
      end   

      run do
        
        if suite_options[:launch_version] == 'ig_launch_1'
          begin
            fhir_search('Slot', params: { _include: 'Slot:schedule', 
              '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
              'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
            })
          rescue
            add_message('error', "Request failed: #{request}")
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
      end

      run do
        
        if suite_options[:launch_version] == 'ig_launch_1'
          begin
            fhir_search('Slot', params: { _include: 'Slot:schedule', 
              '_include:iterate': 'Schedule:actor', status: 'free',  start: ["ge2024-01-01T00:00:00.000+00:00", "le2024-01-03T23:59:59.999+00:00"],
              'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|810101215225'
            })
          rescue
            add_message('error', "Request failed: #{request}")
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
          assert(1<0, 'Response is nil')
        else
          assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}")
        end
      end
    end

    test do
      title 'Test sans certificat'
      description %(
         pas de certificat
      )

      http_client do
        url :base_url
      end
     
      run do
        if suite_options[:launch_version] == 'ig_launch_1'
        get (base_url + 'Slot?_include=Slot:schedule&_include:iterate=Schedule:actor&status=free&start=ge2024-01-01T00:00:00.000+00:00&start=le2024-01-03T23:59:59.999+00:00&schedule.actor:Practitioner.identifier=urn:oid:1.2.250.1.71.4.2.1|810101215225')

        elsif
        get (base_url + 'Slot?_include=Slot:schedule&_include:iterate=Schedule:actor&_include=Slot:service-type-reference&_include:iterate=HealthcareService:organization&status=free&start=ge2024-06-12T16:20:00.000+02:00&start=le2024-06-15T16:20:00.000+02:00&schedule.actor:Practitioner.identifier=urn:oid:1.2.250.1.71.4.2.1%7C810002909371,urn:oid:1.2.250.1.71.4.2.1%7C810001288385')
        end
        assert(response[:status] >= 400 && response[:status] < 500, "Expected status to be in 4xx range, got #{response[:status]}")
      end
    end

  end
end
