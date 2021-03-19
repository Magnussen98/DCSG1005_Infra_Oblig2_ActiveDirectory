# Overskrift - noe Kult !! 
[Link](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2) til GIR repo

## Innholdsfortegnelse
1. "table of content"
2. "klikk her"
3. Klikk her
4. etc 
5. etc



## Mål med prosjektet

Gjennom dette semesteret har vi lært om Windows Server, Active Directory(AD), Powershell, kofugurasjon av nettverk med mer.
Under temaet AD har vi lært om Oragnizational Units, AD-grupper og brukere og GPO, samt administrering av dette via PowerShell. 

Målet med prosjeket er å bli enda bedre kjent med AD og automatisering av oppsett av en AD-struktur ved bruk av script. Vi har under hele prosjektperioden hatt sikkerhet i tankene, og har implemetert dette ved bruk av GPO. 

## Design 
>Hoveddesign

[AD-struktur](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Oppsett%20AD.pdf) 

Beskrivelse av oppsett ? 

>vår NavnKonvensjon (G_ U_ R_ GPO_)


>Forklaring / visning av hvert enkelt script
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
Her drøfter vi sikkerhetsaspekter, oppsett, fordeler/ulemper med mer .... 

Felles for alle scriptene er at de tar inn filer som parameter for oppsett 

Forklaring hvorfor domain Local og Global --> groups

globale og lokale sikkerhetsgrupper 

GPO'er: 
- Comand prompt disablet, men de har tilgang til powershell .. 
- IKKE SIKKERT NOK, MEN ET HAR FÅTT TESTET OSS PÅ GPO


## av Andreas og KristofferHei
