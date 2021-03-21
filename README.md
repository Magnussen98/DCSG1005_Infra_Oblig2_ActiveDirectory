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

Gjennom dette semesteret har vi lært om Windows Server, Active Directory (AD), PowerShell og konfigurasjon av nettverk.   
Under temaet AD har vi lært om Oragnizational Units, AD-grupper og brukere, GPO, samt administrering av dette via PowerShell. 

Målet med prosjeket er å bli enda bedre kjent med AD og automatisering av oppsett og drift av en AD-struktur ved bruk av script. Vi har under hele prosjektperioden hatt sikkerhet i tankene, og har implemetert dette blant annet ved bruk av GPO. 

## Design 
[AD-strukturen](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Oppsett%20AD.pdf) er indelt slik at Ansatte, Ressurser og Maskiner (On-prem) har hver sin OU (Domain controller opprettes by default). Under ansatte ligger en global gruppe med hver avdelingsgruppe samt en OU pr. avdeling. Hver avdeling inneholder sine brukere, som ligger i den globale gruppen til avdelingen.

For ressursene i bedriften er det opprettet en OU pr. ressurs. Pr. nå har vi opprettet Domain Local grupper til ressursene, som vi senere kan knytte opp mot bedriftens BRUKSOMRÅDE(?)  

 PC'er (cl1 i vårt tilfelle) og serverne i AD-strukturen har hver sin OU under On-prem, samt en egen gruppe. Dette tillater å deligere spesifikke restriksjoner/begrensinger til de ulike maskinene. 

## Navnekonvensjon 
Ved opprettelse av objekter i vårt domene har vi valgt å implementere en fast navnestandard. Det vil si at noen av objektene som opprettes får en fast prefiks bokstav etterfulgt av_. F.eks. grupper får prefiks 'G_' etterfulgt av navnet. For OUer er 'U_' brukt for de som inneholder brukere (users). Alle GPO'er vi oppretter starter med 'GPO_' etterfulgt av navnet på OU'en den skal linkes til. 

## Forklaring / visning av hvert enkelt script

### Filer som medsendt parameter
For hvert script som oppretter et eller flere objekter, har vi implementert at de skal sende med en .CSV fil. Filen inneholder strukturen av objektene som skal opprettes i domenet i deg gjeldene scriptet. Ved å sende med filer som parameter gjør vi det enkelt å endre/legge til objekter i domenet. Det gir også mulgihetet for fleksibilitet ved bruk av script i andre domener eller bedrifter. 

### Add OU's

[ScriptADOrganizationUnit.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/OU/ScriptADOrganizationUnit.ps1) er inspirert av [Eric Magidson](https://www.youtube.com/watch?v=eIY1Plo7wXQ&t=37s). Scriptet tar inn en [CSV](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/OU/OUStructure.csv) fil som inneholder OU-strukturen. Ved bruk av innholdet etablerer scriptet OU-strukturen i domenet. 

### Add Groups
[ScriptADGroups.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/tree/master/Groups) bygger på samme prinsipp som [ScriptADOrganizationUnit.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Groups/ScriptADGroups.ps1) , og oppretter Grupper i OU strukturen basert på medsendt [CSV](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Groups/GroupStructure.csv) fil. 

    NB! Standard opprettelse av gruppene er Group Scope default satt til Global, men ressursene i domene (Adgangskort og Skrivere) har vi satt Group Scope til Domain Local.  

<br>

### Add User
-
### Organisering av struktur
Når OU'er, grupper og brukere er opprettet i domenet, kjøres [Organize-GroupsAndComputers.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Organize-GroupsAndComputers.ps1) for å "rydde opp" i strukturen. Kort fortalt legger den alle brukere inn i tilhørende grupper, undergrupper legges inn i hovedgrupper og maskiner flyttes inn i tilhørende OU'er. Vi har laget en mulighet for kun å organisere maskiner eller grupper/brukere hvis ønskelig.  


### GPO
Som henvist i [GPO.MD](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/GPO.md) er inspirasjon til GPO'er under hentet fra blant annet  [Lepide](https://www.lepide.com/blog/top-10-most-important-group-policy-settings-for-preventing-security-breaches/).

Vi har valgt ut noen GPO'er som vi føler er essensielle for sikkerhet ved oppstart av en AD-struktur. Det legges vekt på at GPO'ene valgt her ikke gir best mulig sikkerhet, men er GPO'er vi har valgt "å teste" i domenet. Dette er gjort for å utvikle kunnskap om hvordan GPO fungerer i en AD-struktur. 

Oppsettet setter en del restriksjoner på de ansatte i bedriften ved bruk av Control Panel, Comand prompt, programvareinstalasjon og passordlengde. I tillegg er det opprettet en GPO linket til OU'en PC (cl1) som tilater alle medlemer av gruppen G_ansatte å koble seg på ved bruk av RDP. 

IT-administratorene på sin side har disse begrensningene fjernet (Med unntak av passordlenge). Gjennom GPO får IT-avdelingen administratorrettigheter. Dette gir avdelingen blant annet mulighet for RDP til DC1 og SRV1 samt mulgihet for å administrere domenet fra Cl1. 

### Share
- link til scriptet
- et share pr avdeling som i oppgavebeskrivelsen 
- tar inn en CSV fil 
- tilgang styring
- et felles filområde --> IIS

### Install-IIS
- lagres på felles Filområde
- en valgt nettside 
- 

## Drøfting
I denne seksjonen skal vi drøfte ulike aspekter rundt designet vi har utviklet under dette prosjektet. 

- sikkerhetsaspekter 
- Fordeler/ulemper
  - Med tanke på oppsett, Scripts, etc
    - GPO
  - Valg av grupper (Domain Local og Globale)
  - Globale og lokale sikkerhetsgrupper
  - opprettelse av AD ved bruk av script gjør at ... 
  - Scriptene simplifiserer drift av systemene
  - hva har vi ikke med/ønsker å ta med i en reell sammenheng


Kjøre alle script fra CL1 :: Ikke mulig ... 


GPO: 

 En GPO vi vil drøfte rundt er Comand Prompt. Vi har for de ansatte i bedriften (utenom IT-avdelingen) valgt å deaktivere denne da appen gir brukere mulighet for å kjøre høy-nivå komandoer, uten administrator rettigheter, i følge [Lepide](https://www.lepide.com/blog/top-10-most-important-group-policy-settings-for-preventing-security-breaches/). Ved et reelt oppsett av GPO'er i et domene ville vi brukt blant annet [Windows security baselines](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-security-baselines) som er en "standardkonfigurasjon i industrien". Ved bruk av denne baselinen letter det arbeidet med å gå gjennom 3000+ GPO'er, for så å finne de som er mest relevant for domenet. 
  

Globale og lokale sikkerhetsgrupper / Gruppene i domenet : 

It-avdelingen har fått tildelt administratorrettigheter gjennom den globale gruppen som er medlem av den lokale administrator gruppen i domene. En ansatt får tilgang til ressursene ved at den globale gruppen han/hun er medlem blir medlem av den lokale gruppen for ressursen. Opprettese av grupper ved bruk av [AGDLP](https://en.wikipedia.org/wiki/AGDLP) er Microsofts  annbefaling for opprettelse av "role-based access controls". 



## Konklusjon
Etter en intens arbeidsperiode med mye å sette seg inn, er vi meget fornøyde med resultatet. Vi opplever at det er behagelig å automatisere et AD-oppsett. Oppgaven har vært interesant og lærerik, samtidig som den har bydd på mye diskusjon og problemstillinger. Vi har opplevd arbeidsprosessen som god, og det har blitt en del arbeidstimer over teams, hehe. Selv om vi er personer med helt forskjellige interesster/bakgrunn er vi begge enige om at samarbeidet er godt og at det å "ha en å diskutere med", har vært essensielt for resultatet. 

### Av Andreas Finni Magnussen og Kristoffer Lie



