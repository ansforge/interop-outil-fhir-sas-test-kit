require_relative 'creation_regulateur_test'
require_relative 'creation_regulateur_incorrect_test'
require_relative 'modification_email_regulateur_test'
require_relative 'modification_id_regulateur_test'
require_relative 'modification_nom_regulateur_test'
require_relative 'modification_prenom_regulateur_test'
require_relative 'modification_regulateur_incorrect_test'


module MyTestKit
    class FluxV1Group < Inferno::TestGroup
        title 'Tests des flux V1'
        description 'Tests de conformité aux spécifications SAS - flux V1'
        id :flux_v1_group

        input :base_url

        input :regulator_id,
            title: 'ID du régulateur',
            default: '3456780581'
        
        input :regulator_id_modif,
            title: 'ID du régulateur pour modification',
            description: 'ID différent de celui utilisé pour la création du compte régulateur',
            default: '3456780582'
        
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

        test from: :creation_regulateur_test do
            config(
                inputs: { 
                    regulator_id: { name: :regulator_id },
                    regulator_mail: { name: :regulator_mail },
                    regulator_first_name: { name: :regulator_first_name },
                    regulator_last_name: { name: :regulator_last_name },
                    resource_id: { name: :resource_id }
                }
            )
        end

        test from: :bad_creation_regulateur_test do
            config(
                inputs: { 
                    regulator_id: { name: :regulator_id },
                    regulator_mail: { name: :regulator_mail },
                    regulator_first_name: { name: :regulator_first_name },
                    regulator_last_name: { name: :regulator_last_name },
                    resource_id: { name: :resource_id }
                }
            )
        end

        test from: :modification_email_regulateur_test do
            config(
                inputs: { 
                    regulator_id: { name: :regulator_id },
                    regulator_mail: { name: :regulator_mail_modif },
                    regulator_first_name: { name: :regulator_first_name },
                    regulator_last_name: { name: :regulator_last_name },
                    resource_id: { name: :resource_id }
                    }
            )
        end

        test from: :modification_id_regulateur_test do
            config(
                inputs: { 
                    regulator_id: { name: :regulator_id_modif },
                    regulator_mail: { name: :regulator_mail_modif },
                    regulator_first_name: { name: :regulator_first_name },
                    regulator_last_name: { name: :regulator_last_name },
                    resource_id: { name: :resource_id }
                    }
            )
        end

        test from: :modification_nom_regulateur_test do
            config(
                inputs: { 
                    regulator_id: { name: :regulator_id_modif },
                    regulator_mail: { name: :regulator_mail_modif },
                    regulator_first_name: { name: :regulator_first_name },
                    regulator_last_name: { name: :regulator_last_name_modif },
                    resource_id: { name: :resource_id }
                    }
            )
        end

        test from: :modification_prenom_regulateur_test do
            config(
                inputs: { 
                    regulator_id: { name: :regulator_id_modif },
                    regulator_mail: { name: :regulator_mail_modif },
                    regulator_first_name: { name: :regulator_first_name_modif },
                    regulator_last_name: { name: :regulator_last_name_modif },
                    resource_id: { name: :resource_id }
                    }
            )
        end

        test from: :modification_regulateur_incorrect_test do
            config(
                inputs: {
                    regulator_id: { name: :regulator_id_modif },
                    regulator_mail: { name: :regulator_mail_modif },
                    regulator_first_name: { name: :regulator_first_name_modif },
                    regulator_last_name: { name: :regulator_last_name_modif },
                    resource_id: { name: :resource_id }
                }
            )
        end
    end
end