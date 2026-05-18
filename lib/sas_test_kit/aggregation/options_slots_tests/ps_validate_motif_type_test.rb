module SasTestKit
    module OptionSlot
        class ValidateMotifType < Inferno::Test
            title 'Vérification types de consultation'
            id :ps_validate_motif_type
            short_id '4.6.03'
            description %(
            Verification types de consultation retournés
            )

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
            
            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
                SLOT_PROFILE_URL = suite_options[:launch_version] == 'ig_launch_1' ? 'http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur' : 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator'

                lst_type_consultation_retournes = evaluate_fhirpath(resource: bundle, path: "entry.where(resource.meta.profile='#{SLOT_PROFILE_URL}').resource.serviceType.coding.code.distinct()")   
                str_consultation = ""
                lst_type_consultation_retournes.each_with_index do |type_consult, int|
                  str_consultation = str_consultation + type_consult["element"].to_s + "," unless type_consult["element"].to_s == "604"
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
    end
end