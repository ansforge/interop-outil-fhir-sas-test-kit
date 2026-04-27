module SasTestKit
    class ConnexionLGATest < Inferno::Test
        title "Accès au LGA"
        id :sso_lga
        description %(
        )
        run do
            sso_url = scratch[:sso_url] + "&origin=sas-preprod"
            add_message('info', "URL de redirection : #{sso_url}")
            
            external_url = "#{sso_url}"

            message = %(
                ### Étape 2 - Accès au LGA

                Cliquez sur le lien ci-dessous pour ouvrir la page de connexion et être redirigé vers le LGA :

                [Accéder au LGA](#{external_url})
            )
            omit message

        end
    end
end