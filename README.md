# Overskrift - noe Kult !! 
[Link](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2) til GIR repo

## Innholdsfortegnelse
1. "table of content"
2. "klikk her"
3. Klikk her
4. etc 
5. etc



## Mål med prosjektet
Forklaring ut fra oppgavebeskrivelse (relativt kort)


## Design 
>Hoveddesign

Linke til filene i Raporten? 

>Forklaring / visning av hvert enkelt script
### Add OU's

Scriptet "ScriptADOrganizationUnit.ps1" er inspirert av [Eric Magidson](https://www.youtube.com/watch?v=eIY1Plo7wXQ&t=37s). Det tar inn en CSV som inneholder OU-strukturen og etablerer denne i vårt domene. 



### Add Groups 
"ScriptADGroups.ps1" bygger på samme prinsipp som "ScriptADOrganizationUnit.ps1", og oppretter Grupper i OU strukturen basert på medsendt CSV fil. 

    NB! Standard opprettelse av gruppene er Group Scope default global, men for ressursene i domene (adgangskort og Skrivere) har vi satt til Domain Local.  


<br>

### Add User
### Organize-GroupsAndComputers
### GPO
Som henvist i "GPO.MD" er inspirasjon til GPO'er hentet fra blant annet  [Lepide](https://www.lepide.com/blog/top-10-most-important-group-policy-settings-for-preventing-security-breaches/).

Vi har valgt ut noen GPO'er som vi føler er essensielle for oppstart av en AD struktur. 


Oppsettet setter en del restriksjoner på de ansatte i bedriften ved bruk av Control Panel, Comand prompt, programvare instasasjon og passordlengde. I tillegg er det opprettet en GPO linket til CL1, som lar alle ansatte i bedriften logge på maskinen. 

IT-administratorene på sin side har disse begrensningene fjernet (Med unntak av passordlenge). Gjennom GPO får IT-avdelingen Administratorrettigheter for å .... MER HER ... Dette gir IT-ansatte mulighet for RDP til DC1 og SRV1. 


<br>
Comand prompt disablet, men de har tilgang til powershell .. 

IKKE SIKKERT NOK, MEN ET HAR FÅTT TESTET OSS PÅ GPO
<br>

### Share

### Install-IIS


## Drøfting
Her drøfter vi sikkerhetsaspekter, oppsett, fordeler/ulemper med mer .... 

Felles for alle scriptene er at de tar inn filer som parameter for oppsett 

Forklaring hvorfor domain Local og Global --> groups


## av Andreas og KristofferHei
