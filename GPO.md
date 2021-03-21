# GPO Struktur: 
For opprettelse av GPO bruker vi GUI. 

Inspirasjon til GPO er hentet fra [Lepide](https://www.lepide.com/blog/top-10-most-important-group-policy-settings-for-preventing-security-breaches/) og undervisninger. 

For ansatte ønsker vi å gi restriksjoner slik at de ikke har tilgang til for ekempel Kontorllpalenet eller andre applikasjoner de kan utføre sikkerhetstruende handlinger. Restriksjonene vi har valgt å i tillegg til Knotrollpanelet nevnt over er comand prompt og programvareinstalsjon. Det er også satt at minste passordlengde er 10 karakterer. GPO er for de ansatte i bedriften er også brukt til å sette defaukt startpage i Internett Explorer.

IT-avdelingen har på sin side fått disse restiksjonene opphevet da de skal utføre administrative oppgaver i domenet. Derfor er avdelingen gitt admin rettigheter. Dette gir brukerne i avdelingen mulighet for RDP til alle maskiner i domenet. CL1 sin GPO tillater at alle som er medlem av Domain Local gruppen G_ansatt kan koble seg opp via RDP. Under viser vi hvordan en oppretter GPOene manuelt:


## Ansatt
    Åpne Browse for a Group Policy Object med komandoen "gpme" i PowerShell. 
    Naviger under Annsatt, høyereklikk og klikk "new". Gi den navnet GPO_Ansatt og dobbelttrykk for å åpne

### Controll Panel

Gå til:

    User Configuration -> Policies -> Administrative Templates -> Control Panel
    Dobbeltrykk på "Prohibit access to Control Panel and PC settings" og sett den til enable -> apply -> OK

### Comand Prompt
 Gå til: 

    User Configuration -> Policies -> Administrative Templates -> System
    Dobbeltklikk på "Prevent access to the command prompt" -> enable -> klikk Apply -> ok

### Programvare intalasjon
Gå til: 

    Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Windows Installer
    Dobbeltrykk "Prohibit User Install" -> enable -> klikk Apply --> ok

### Minimum Passord: 

Gå til: 

    Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Account -> Policies -> Password Policy
    Dobbeltrykk "Minimum Password Length" -> 10 -> klikk Apply --> ok

### Sette IIS som "default startpage" '
Gå til: 

    User Configuration -> Policies -> Administrative Templates -> Windows Components -> Internet Explorer.
    Finn  "Disable changing home page settings", ca midt på. Dobbeltklikk -> enable 
    Finn frem IP-adressen til SRV1 (server brukt til oppsett av IIS), og lim den inn under homepage
    Klikk apply --> ok og lukk fanen. 


## IT-admin

    Åpne Browse for a Group Policy Object med komandoen "gpme" i PowerShell. 
    Naviger til ansatt -> IT-admin
    Høyreklikk -> new og gi den navnet GPO_IT-admin
    Dobbletklikk for å endre objektet. 

### Control Panel

Gå til:

     User Configuration -> Policies -> Administrative Templates  -> Control Panel
    Dobbeltrykk på "Prohibit access to Control Panel and PC settings" - > disabled --> apply --> OK


### Comand Prompt

Gå til:

    User Configuration -> Policies -> Administrative Templates -> System
    Dobbeltklikk på "Prevent access to the command prompt" -> disable -> klikk Apply så ok


### Administrator 
    Åpne Browse for a Group Policy Object med komandoen "gpme" i PowerShell. 
    Påse at du står i  "sec.core"
    Høyreklikk -> new og gi den navnet GPO_IT-Admin_Rettigheter 
    Dobbletklikk for å endre objektet. 

Gå til:

    Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Restricted Groups
    Høyreklikk -> add group -> G_IT-admin -> ok
    Under "this group is a member of   " legger du inn: 
    Administrators'
    klikk ok -> apply -> ok


## cl1
    Åpne Browse for a Group Policy Object med komandoen "gpme" i PowerShell. 
    Naviger til On-prem -> PC -> høyreklikk -> new og gi den navnet GPO_CL1
    Dobbletklikk for å åpne

### Tillat RDP
 Gå til: 

    Computer Configuration -> Preferences -> Control Panel Settings -> local users and groups 
    Høyreklikk -> new -> local group -> velg "Remote Desktop Users (built-in)" --> add
    Under members klikk add --> legg inn gruppen G_Ansatt

