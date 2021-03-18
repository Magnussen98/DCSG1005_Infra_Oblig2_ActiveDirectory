# dette scriptet vil guide gjennom hvordan vi vil setter Opp GPOene



#######################################################################################
#################################    Ansatt      ######################################
#######################################################################################


    #Bruk GPME for å komme til område du skal opprette GPO
        gpme 
    #klikk deg inn i ansatt --> høyreklikk --> new 
    #gi den navnet:
        GPO_Ansatt 
    #dobbeltrykk for å åpne



################################# Controll Panel  ######################################
    #Under GPO_ansatt: 
    #User Configuration -> Preferences -> Administrative Templates -> Control Panel
    #Dobbeltrykk på "Prohibit access to Control Panel and PC settings"
    #sett den til enable --> apply --> OK


################################# Comand Prompt ######################################
    #Under GPO_ansatt: 
    #User Configuration -> Policies -> Administrative Templates -> System
    #dobbeltklikk på "Prevent access to the command prompt" -> enable
    #klikk Apply --> ok

################################# Software instalasjon ################################
    #Under GPO_ansatt: 
    #Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Windows Installer
    #Dobbeltrykk "Prohibit User Install" -> enable
    #klikk Apply --> ok



################################# Minumum Passord ################################
    #Under GPO_ansatt: 
    #Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Account Policies -> Password Policy
    #Dobbeltrykk "Minimum Password Length" -> 10
    #klikk Apply --> ok



#######################################################################################
#################################    IT-admin   #######################################
#######################################################################################



     #GPME tar deg til område du skal opprette GPO
    gpme

    #klikk deg inn på ansatt --> U_iT-admin
    #høyreklikk --> new --> kall GPO for:
    GPO_IT-admin
    #dobbeltklikk for å komme inn i GPOen


################################# ADMINISTRATOR ######################################

    #Computer Configuration -> Policies -> 
    #Windows Settings -> Security Settings -> Restricted Groups
    #høyreklikk --> add group --> 
    #legg inn 
        G_IT-admin
    #Klikk ok
    #Under "members of this group" legger du inn: 
        Administrators
    #klikk ok --> apply --> ok


################################# Controll Panel ######################################
#Under GPO_IT-admin: 
    #User Configuration -> Preferences -> Administrative Templates -> Control Panel
    #Dobbeltrykk på "Prohibit access to Control Panel and PC settings"
    #sett den til disabled --> apply --> OK


################################# Comand Prompt ######################################
    #Under GPO_IT-admin: 
    #User Configuration -> Policies -> Administrative Templates -> System
    #dobbeltklikk på "Prevent access to the command prompt" -> disable
    #klikk Apply --> ok


################################# Software instalasjon ################################
    #Under GPO_IT-admin: 
    #Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Windows Installer
    #Dobbeltrykk "Prohibit User Install" -> disable
    #klikk Apply --> ok


#######################################################################################
#################################       Cl1     #######################################
#######################################################################################

    #Bruk GPME for å komme til område du skal opprette GPO
        gpme 
    #klikk deg inn i ansatt --> høyreklikk --> new 
    #gi den navnet:
        GPO_cl1
    #dobbeltrykk for å åpne

################################# Allow RDP cl1  ######################################
    
    #Computer Configuration -> Preferences -> Control Panel Settings ->local users and groups 
    #høyreklikk -> new -> local group -> velg "Remote Desktop Users (built-in)" --> add
    #under members klikk add --> legg inn: 
        G_Ansatt
    #klikk ok


################################### Sjekk av GPO #################################
    #Bruk Gpmc for å komme til oversikten over GPOer: 
        gpmc 
    #ansatt, IT-admin og cl1 skal nå ha hver sin GPO. 
    #Logg på CL1 som administrator og kjør gpupdate for at gjelende Policy skal fungere
        gpupdate /force
    #Fra cl1, gå inn i dc1 og srv 1 og oppdater policy på lik linje som over 

