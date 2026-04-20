module SasTestKit
    class ConnexionSASTest < Inferno::Test
        title "Connexion à la plateforme du SAS"
        id :sso_sas
        description %(
        )
        run do
            external_url = "https://seconnecter.preproduction.santefr.esante.gouv.fr/realms/sas/protocol/openid-connect/auth?client_id=sas&response_type=code&scope=openid%20email%20profile%20pro_sante_connect&redirect_uri=https%3A//sas.preproduction.santefr.esante.gouv.fr/openid-connect/sas&state=wHZyTU0sm9DVkflkPgaRrMloooWDRw4k6e-eUr8knbI&prompt=login%20login"

            message = %(
                ### Étape 1 - Connexion à la plateforme du SAS

                Cliquez sur le lien ci-dessous pour ouvrir la plateforme :

                [Accéder à la plateforme du SAS](#{external_url})
            )
            omit message
        end
    end
end