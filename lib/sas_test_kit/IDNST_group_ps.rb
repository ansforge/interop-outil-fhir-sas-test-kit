module MyTestKit
  class IDNSTGroupPS < Inferno::TestGroup
    title 'Contrôles IDNST'
    description 'Contrôles sur l\'identifiant de la structure'
    id :idnst_group_ps

    
    test do
      title 'Recherche par RPPS - Initialisation requête'
      description %(
        Initialisation requête
      )

      input :practitioner_id,
            title: 'RPPS',
            description: 'Renseigner le RPPS (préfixé par 8) d\'un PS qui travaille dans un lieu avec un identifant de structure'

      run do

        #prévoir de gérer les time zone
        formatted_start_date = Time.now.strftime("%Y-%m-%dT%H:%M:%S")

        three_days_later = Time.now + (3 * 24 * 60 * 60) # 3 days in seconds

        # Cap at 72 hours (3 days)
        max_limit = Time.now + (72 * 60 * 60)

        # End of third day (23:59:59)
        end_of_third_day = (Time.now + (2 * 24 * 60 * 60)).end_of_day rescue Time.new(Time.now.year, Time.now.month, Time.now.day + 2, 23, 59, 59)

        # Final capped time
        capped_time = [three_days_later, max_limit, end_of_third_day].min

        # Format capped time
        formatted_end_date = capped_time.strftime("%Y-%m-%dT%H:%M:%S")
        scratch[:DateFin] = formatted_end_date
    
        hash = {
        _include: 'Slot:schedule', 
        '_include:iterate': 'Schedule:actor',
        'schedule.actor:Practitioner.identifier': 'urn:oid:1.2.250.1.71.4.2.1|'+ practitioner_id,
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
        title 'Vérification IDNST'
      description %(
       Présence et format IDNST
      )
      run do
        bundle = scratch[:Bundle]
    
        IDNST = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.organization.identifier.value')   
        valueIDNST = IDNST&.dig(0, "element").to_s
        add_message('info', "IDNST: " + valueIDNST) 

        assert valueIDNST && !valueIDNST.empty?, "L'identifiant de structure est manquant"
        
        PATTERNS_ANY = [
        /\A1[0-9]{9}\z/,  # FINESS
        /\A3[0-9]{14}\z/, # SIRET
        /\A4[0-9]{14}\z/   # RPPSRANG
        ]

        assert (matches_any = PATTERNS_ANY.any? { |rx| rx.match?(valueIDNST) }), "L'IDNST doit être au bon format"

      end
    end

  end
end
