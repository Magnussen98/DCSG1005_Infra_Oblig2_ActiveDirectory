# AD-struktur Albegra-a2
[Link](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2) til GIR repo

## Innholdsfortegnelse
1. Mål med prosjektet
2. Design
   1. Generelt/intro/kort beskrivelse
   2. Navnekonvensjon/navnestandard
   3. Forklaring av hvert enkelt script
      1. Filer som parameter
      2. Add OU's
      3. Add Groups
      4. Add User
      5. Organisering av struktur
      6. GPO
      7. Share (Filområder)
      8. Install-IIS
3. Drøfting
4. Konklusjon



## Mål med prosjektet

Gjennom dette semesteret har vi lært om Windows Server, Active Directory(AD), Powershell og kofugurasjon av nettverk.   
Under temaet AD har vi lært om Oragnizational Units, AD-grupper og brukere, GPO, samt administrering av dette via PowerShell. 

Målet med prosjeket er å bli enda bedre kjent med AD og automatisering av oppsett og drift av en AD-struktur ved bruk av script. Vi har under hele prosjektperioden hatt sikkerhet i tankene, og har implemetert dette blant annet ved bruk av GPO. 

## Design 
[AD-strukturen](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Oppsett%20AD.pdf) er indelt slik at Ansatte, Ressurser og Maskiner (On-prem) har hver sin OU (Domain controller opprettes by default). Under ansatte ligger en global gruppe med hver avdelingsgruppe samt en OU pr. avdeling. Hver avdeling inneholder sine brukere, som ligger i den globale gruppen til avdelingen.

For ressursene i bedriften er det opprettet en OU pr. ressurs. Pr. nå har vi opprettet Domain Local grupper til ressursene, som vi senere kan knytte opp mot bedriftens BRUKSOMRÅDE(?)  

 PC'er (cl1 i vårt tilfelle) og serverne i AD-strukturen har hver sin OU under On-prem, samt en egen gruppe. Dette tillater å deligere spesifikke restriksjoner/begrensinger til de ulike maskinene. 



## Navnekonvensjon 
Ved opprettelse av objekter i vårt domene har vi valgt å implementere en fast navnestandard. Det vil si at noen av objektene som opprettes får en fast prefiks bokstav etterfulgt av_. F.eks. grupper får prefiks 'G_' etterfulgt av navnet. For OUer er 'U_' brukt for de som inneholder brukere (users) mens 'R_' er brukt for ressurser. Alle GPO'er vi oppretter starter med 'GPO_' etterfulgt av navnet på OU'en den skal linkes til.  FORKLARE HVORFOR (?)

## Forklaring / visning av hvert enkelt script

### Filer som parameter

### Add OU's

[ScriptADOrganizationUnit.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/OU/ScriptADOrganizationUnit.ps1) er inspirert av [Eric Magidson](https://www.youtube.com/watch?v=eIY1Plo7wXQ&t=37s). Scriptet tar inn en [CSV](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/OU/OUStructure.csv) fil som inneholder OU-strukturen. Ved bruk av innholdet etablerer scriptet OU-strukturen i domenet. 

<br>

### Add Groups
[ScriptADGroups.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/tree/master/Groups) bygger på samme prinsipp som [ScriptADOrganizationUnit.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Groups/ScriptADGroups.ps1) , og oppretter Grupper i OU strukturen basert på medsendt [CSV](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Groups/GroupStructure.csv) fil. 

    NB! Standard opprettelse av gruppene er Group Scope default satt til Global, men ressursene i domene (adgangskort og Skrivere) har vi satt til Domain Local.  


<br>

### Add User
### Organisering av struktur
Når OU'er, grupper og brukere er opprettet i domenet, kjøres [Organize-GroupsAndComputers.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Organize-GroupsAndComputers.ps1) for å "rydde opp" strukturen. Kort fortalt legger den alle brukere inn i tilhørende grupper, undergrupper legges inn i hovedgrupper og maskiner flyttes inn i tilhørende OU'er. Vi har laget en mulighet for kun å organisere maskiner eller grupper/brukere ved senere bruk.  

<br>

### GPO
Som henvist i [GPO.MD](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/GPO.md) er inspirasjon til GPO'er hentet fra blant annet  [Lepide](https://www.lepide.com/blog/top-10-most-important-group-policy-settings-for-preventing-security-breaches/).

Vi har valgt ut noen GPO'er som vi føler er essensielle for sikkerhet ved oppstart av en AD struktur. 


Oppsettet setter en del restriksjoner på de ansatte i bedriften ved bruk av Control Panel, Comand prompt, programvare instasasjon og passordlengde. I tillegg er det opprettet en GPO linket til CL1(ISHHHHH), som lar alle ansatte i bedriften logge på maskinen. 

IT-administratorene på sin side har disse begrensningene fjernet (Med unntak av passordlenge). Gjennom GPO får IT-avdelingen Administratorrettigheter, dette gir avdelingen blant annet mulighet for RDP til DC1 og SRV1 samt mulgihet for å administrere domenet. 


<br>

<br>

### Share

### Install-IIS


## Drøfting
- intro
- sikkrehetsaspekter 
- Fordeler/ulemper
  - Med tanke på oppsett, Scripts, etc
    - GPO
  - Valg av grupper (Domain Local og Globale)
  - Globale og lokale sikkerhetsgrupper
  - oppretelse av AD ved bruk av script gjør at ... 
  - Scriptene simplifiserer drift av systemene
  - hva har vi ikke med/ønsker å ta med i en reell sammenheng

Her drøfter vi sikkerhetsaspekter, oppsett, fordeler/ulemper med mer .... 

Felles for alle scriptene er at de tar inn filer som parameter for oppsett 

Forklaring hvorfor domain Local og Global --> groups

globale og lokale sikkerhetsgrupper 

GPO'er: 
- Comand prompt disablet, men de har tilgang til powershell .. 
- IKKE SIKKERT NOK, MEN ET HAR FÅTT TESTET OSS PÅ GPO

## Konklusjon
- hva vi har lært 
- hva vi synes om oppgaven
- arbeidsprosessen
- hvilke muligheter dette gir oss vidre

## av Andreas og Kristoffer
