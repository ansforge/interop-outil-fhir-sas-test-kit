require_relative 'creation_regulateur_idnps_test'
require_relative 'creation_regulateur_uuid_test'
require_relative 'creation_regulateur_incorrecte_test'
require_relative 'modification_email_regulateur_test'
require_relative 'modification_id_regulateur_test'
require_relative 'modification_typeid_regulateur_test'
require_relative 'modification_nom_regulateur_test'
require_relative 'modification_prenom_regulateur_test'
require_relative 'modification_regulateur_incorrecte_test'
require_relative 'modification_deshabilitation_test'
require_relative 'modification_habilitation_test'
require_relative 'put_as_create_test'
require_relative 'idnps_reattribution_test.rb'


module MyTestKit
    class FluxV1Group < Inferno::TestGroup
        title 'Tests des flux V1'
        description 'Tests de conformité aux spécifications SAS - flux V1'
        id :flux_v1_group

        input :base_url

        input :regulator_id,
            title: 'ID du régulateur (format IDNPS)',
            default: '3456780581/11242343'
        
        input :regulator_id_modif,
            title: 'ID du régulateur pour modification',
            description: 'ID différent de celui utilisé pour la création du compte régulateur',
            default: '3456780581/11242344'
        
        input :regulator_mail,
            title: 'Email du régulateur',
            default: 'sebastien.loridon@test.com'

        input :regulator_mail_modif,
            title: 'Email du regulateur pour modification',
            description: 'Email différent de celui utilisé pour la création du compte régulateur',
            default: 'sebastien.loridon.modif@test.com'
        
        input :regulator_first_name,
            title: 'Prénom du régulateur',
            default: 'Sébastien'
        
        input :regulator_first_name_modif,
            title: 'Prénom du régulateur pour modification',
            description: 'Prénom différent de celui utilisé pour la création du compte régulateur',
            default: 'Sébastien-modif'
        
        input :regulator_last_name,
            title: 'Nom du régulateur',
            default: 'Loridon'

        input :regulator_last_name_modif,
            title: 'Nom du régulateur pour modification',
            description: 'Nom différent de celui utilisé pour la création du compte régulateur',
            default: 'Loridon-modif'
        
        input :resource_id,
            title: 'ID de la ressource à récupérer',
            default: 'example-regulator-1'

        test from: :creation_regulateur_idnps_test

        test from: :creation_regulateur_uuid_test

        test from: :bad_creation_regulateur_test

        test from: :modification_deshabilitation

        test from: :modification_habilitation

        test from: :modification_email_regulateur_test

        test from: :modification_id_regulateur_test 

        test from: :modification_typeid_regulateur_test

        test from: :modification_nom_regulateur_test 

        test from: :modification_prenom_regulateur_test

        test from: :modification_regulateur_incorrecte_test

        test from: :put_as_create

        test from: :idnps_reattribution_test
    end
end