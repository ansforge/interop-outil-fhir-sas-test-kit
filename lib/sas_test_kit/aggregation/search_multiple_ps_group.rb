require_relative 'setup_test'

module MyTestKit
    class SearchMultiplePsGroup < Inferno::TestGroup
        title 'Flux Agrégateur - Recherche multi-PS'
        description %(
            Ce groupe réalise une série de vérifications sur le **Bundle de réponse** renvoyé par le **flux Agrégateur - recherche de créneaux**, dans le cas où **plusieurs professionnels de santé** peuvent être retournés pour une même requête.  
            Ces contrôles visent à garantir la conformité des données fournies selon les profils et règles définis dans les spécifications SAS.

            Les tests de ce groupe portent notamment sur :
            - la **présence attendue de plusieurs Practitioner**, chacun correspondant à un RPPS distinct fourni en entrée ;
            - la **présence d'au moins deux PractitionerRole**, reflétant les rôles d'exercice des PS remontés ;
            - la présence d'**au moins deux Schedule**, conformément au retour de disponibilités associées à chacun des PS.

            Ce groupe complète les contrôles réalisés pour le cas « PS avec un seul lieu », en s'assurant que le serveur gère correctement les **scénarios multi-correspondances** dans le flux Agrégateur.
        )
        id :search_multiple_ps_group
        input :practitioner_id3,
            title: 'RPPS',
            description: "Renseigner les RPPS (préfixé par 8) d'un PS pouvant être remonté dans une même recherche que celui ci-dessous"

        input :practitioner_id4,
            title: 'RPPS',
            description: 'Renseigner les RPPS (préfixé par 8) un PS pouvant être remonté dans une même recherche que celui ci-dessus'
        
        test from: :slot_search_setup do
            config(
                inputs: { 
                    practitioner_id: { name:  :practitioner_id3},
                    practitioner_id_opt: { name: :practitioner_id4, hidden: false }
                }
            )
        end

        test do
            title 'Vérification de la présence de deux ressources Practitioner'
            description %(
                ## Description

                Ce test réalise une vérification de la **présence de deux ressources Practitioner** dans le Bundle de réponse.  
                Il est attendu que la recherche multi-PS retourne **exactement deux** profils *FrPractitionerAgregateur* correspondant aux deux RPPS renseignés en entrée.
            )
            run do
                scratch[:practitioners] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource')
                assert(scratch[:practitioners].length == 2, "Le Bundle doit contenir exactement deux ressources Practitioner, en a #{scratch[:practitioners].length}")
            end
        end

        test do
            title "Vérification de la présence d'au moins deux ressources PractitionerRole"
            description %(
                ## Description

                Ce test effectue une vérification sur les **ressources PractitionerRole** retournées dans le Bundle.  
                Il est attendu que la recherche multi-PS présente **au moins deux ressources** *FrPractitionerRoleExerciceAgregateur*, reflétant la présence de plusieurs PS dans la réponse.
            )
            run do
                scratch[:practitioner_roles] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource')
                assert(scratch[:practitioner_roles].length >= 2, "Le Bundle doit contenir au moins deux ressources PractitionerRole, en a #{scratch[:practitioner_roles].length}")
            end
        end

        test do
            title "Vérification de la présence d'au moins deux ressources Schedule"
            description %(
                ## Description

                Ce test réalise une vérification sur les **ressources Schedule** du Bundle de réponse.  
                La recherche multi-PS doit retourner **au minimum deux ressources Schedule**, chacune correspondant à un professionnel remonté par le flux Agrégateur.
            )
            run do
                scratch[:schedules] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource')
                assert(scratch[:schedules].length >= 2, "Le Bundle doit contenir au moins deux ressources Schedule, en a #{scratch[:schedules].length}")
            end
        end
    end
end
