module SasTestKit
  class OptionSlotGroupCPTS < Inferno::TestGroup
    title 'Options sur les créneaux'
    description 'Contrôles sur les données optionnelles des créneaux'
    id :optionslots_group_cpts

    input :type_slot,
            title: 'Quels types de créneaux sont disponibles dans la solution ?',
            type: 'checkbox',
            options: {
              list_options: [
                {
                  label: 'Créneaux grand public',
                  value: 'PUBLIC'
                },
                {
                  label: 'Créneaux réservés aux professionnels',
                  value: 'PRO'
                },
                {
                  label: 'Créneaux typés SNP',
                  value: 'SNP'
                },
                {
                  label: 'Créneaux privés',
                  value: 'private'
                },
                    {
                  label: 'Créneaux CPTS',
                  value: 'CPTS'
                }
              ]
            }

    input :type_consultation,
            title: 'Quels sont les types de consultations au niveau des créneaux ?',
            type: 'checkbox',
            options: {
              list_options: [
                {
                  label: 'Au cabinet',
                  value: 'AMB'
                },
                {
                  label: 'En téléconsultation',
                  value: 'VR'
                },
                {
                  label: 'Visite à domicile',
                  value: 'HH'
                }
              ]
            }       
   
    
    test do
      title 'Recherche par RPPS - Initialisation requête'
      description %(
        Initialisation requête
      )

      input :practitioner_id,
            title: 'RPPS',
            description: 'Renseigner le RPPS (préfixé par 8) d\'un PS qui possède des créneaux dans les 72 heures avec tous les types possibles sélectionnés plus haut et disponibles dans la solution'

      run do

        #prévoir de gérer les time zone
        formatted_start_date = Time.now.strftime("%Y-%m-%dT%H:%M:%S")
        three_days_later = Time.now + (3 * 24 * 60 * 60)
        max_limit = Time.now + (72 * 60 * 60)
        end_of_third_day = (Time.now + (2 * 24 * 60 * 60)).end_of_day rescue Time.new(Time.now.year, Time.now.month, Time.now.day + 2, 23, 59, 59)
        capped_time = [three_days_later, max_limit, end_of_third_day].min
        formatted_end_date = capped_time.strftime("%Y-%m-%dT%H:%M:%S")

        scratch[:DateFin] = formatted_end_date
    
        hash =  {
        _include: [
          'Slot:schedule',
          'Slot:service-type-reference'
        ],
        '_include:iterate': [
        'Schedule:actor',
        'HealthcareService:organization'
        ],
        'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + practitioner_id,
        start: ["ge#{formatted_start_date}.000", "le#{formatted_end_date}.000"],
        status: 'free'
        }

        fhir_search('Slot', params: hash)

        #Stockage pour les autres tests
        scratch[:Bundle] = resource
        scratch[:IDNPS] = practitioner_id
  
        assert_response_status(200)
        assert_resource_type('Bundle')
       
      end
      
    end

    
     test do
        title 'Vérification types de créneaux'
      description %(
       Verification type de créneaux
      )
    
      run do
        bundle = scratch[:Bundle]
    
        lst_type_creneaux_retournes = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource.meta.security.code.distinct()')   
        str_creneaux = ""
        lst_type_creneaux_retournes.each_with_index do |type_creneau, int|
          str_creneaux = str_creneaux + type_creneau["element"].to_s + "," 
        end

        str_creneaux_dispo = ""
        type_slot.each_with_index do |type_creneau, int|
          str_creneaux_dispo = str_creneaux_dispo + type_creneau.to_s + ","
        end  

        add_message('info', "types de créneaux retournés: " + str_creneaux.to_s) 
        add_message('info', "types de slot disponibles: " + str_creneaux_dispo.to_s) 


       normalize = ->(s) {
        s.split(',')
       .map { |x| x.strip }
       .reject(&:empty?)
       .map(&:upcase)
       .to_set
        }

      returned_set  = normalize.call(str_creneaux)
      available_set = normalize.call(str_creneaux_dispo)

      manquants = available_set - returned_set
      supplementaire =  returned_set - available_set

      add_message('info', "supplémentaires: " + supplementaire.to_a.join(', '))

      assert manquants.empty?, "Les types suivants prévus dans la solution ne sont pas retournés au niveau des créneaux : #{manquants.to_a.join(', ')}"
      assert supplementaire.empty?, "Les types suivants sont retournés au niveau des créneaux alors qu'ils ne sont pas déclarés comme disponibles dans la solution : #{supplementaire.to_a.join(', ')}"
      end
    end

     test do
        title 'Vérification types de consultation'
      description %(
       Verification types de consultation retournés
      )
    
      run do
        bundle = scratch[:Bundle]
    
        lst_type_consultation_retournes = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource.serviceType.coding.where(system="http://terminology.hl7.org/CodeSystem/v3-ActCode").code.distinct()')   
        str_consultation = ""
        lst_type_consultation_retournes.each_with_index do |type_consult, int|
          str_consultation = str_consultation + type_consult["element"].to_s + "," 
        end

        str_consultation_dispo = ""
        type_consultation.each_with_index do |type_consult, int|
          str_consultation_dispo = str_consultation_dispo + type_consult.to_s + ","
        end  

        add_message('info', "types de créneaux retournés: " + str_consultation.to_s) 
        add_message('info', "types de slot disponibles: " + str_consultation_dispo.to_s) 


       normalize = ->(s) {
        s.split(',')
       .map { |x| x.strip }
       .reject(&:empty?)
       .map(&:upcase)
       .to_set
        }

      returned_set  = normalize.call(str_consultation)
      available_set = normalize.call(str_consultation_dispo)

      manquants = available_set - returned_set
      supplementaire =  returned_set - available_set

      assert manquants.empty?, "Les types suivants prévus dans la solution ne sont pas retournés au niveau des créneaux : #{manquants.to_a.join(', ')}"
      assert supplementaire.empty?, "Les types suivants sont retournés au niveau des créneaux alors qu'ils ne sont pas déclarés comme disponibles dans la solution : #{supplementaire.to_a.join(', ')}"
      end
    end


     test do
        title 'Tests condition'
      description %(
       Testconditions
      )
      run do
        skip_if type_slot.include?('PUBLIC'), 'ce test est omis si l\'éditeur gère les créneaux public'
      end
    end

  end
end
