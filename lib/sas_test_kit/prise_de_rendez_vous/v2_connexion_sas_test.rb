module SasTestKit
    class ConnexionSASTest < Inferno::Test
        title "Connexion à la plateforme du SAS"
        id :sso_sas
        description %(
        )
        run do
            sso_url = scratch[:sso_url] + "&origin=sas-preprod"
            add_message('info', "URL de redirection : #{sso_url}")
            
            external_url = "#{sso_url}"

            message = %(
                ### Étape 1 - Connexion à la plateforme du SAS

                Cliquez sur le lien ci-dessous pour ouvrir la plateforme :

                [Accéder à la plateforme du SAS](#{external_url})
            )
            omit message
        end
    end
end