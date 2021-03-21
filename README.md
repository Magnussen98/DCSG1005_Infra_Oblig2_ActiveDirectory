# AD-struktur Albegra-a2
[Link](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2) til GIT repo

## Innholdsfortegnelse
1. Mål med prosjektet
2. Design
   1. Generelt
   2. Navnestandard
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
[AD-strukturen](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Oppsett%20AD.pdf) er indelt slik at Ansatte, Ressurser og Maskiner (On-prem) har hver sin OU (Domain controller opprettes by default). Under ansatte ligger en Domain Local gruppe med hver avdelingsgruppe samt en OU pr. avdeling. Hver avdeling inneholder sine brukere, som ligger i den globale gruppen til avdelingen.

Ressursene i domenet er lagt i egen OU som Domain Local grupper. PCene (cl1 i vårt tilfelle) og serverne i AD-strukturen har hver sin OU under On-prem, samt en egen gruppe. Dette tillater å deligere spesifikke rettigheter til de ulike maskinene. 

## Navnekonvensjon 
Ved opprettelse av objekter i vårt domene har vi valgt å implementere en fast navnestandard. Det vil si at noen av objektene som opprettes får en fast prefiks bokstav etterfulgt av "_". F.eks. grupper får prefiks 'G_', etterfulgt av navnet. For OUer er 'U_' brukt for de som inneholder brukere (users). Alle GPO'er vi oppretter starter med 'GPO_' etterfulgt av navnet på OU'en den skal linkes til. 

## Forklaring av hvert enkelt script



## Drøfting

Når en bruker blir lagt til i "add-users" scriptet så har vi også satt parameteren: "[changePasswordAtLogon](https://docs.microsoft.com/en-us/powershell/module/addsadministration/new-aduser?view=windowsserver2019-ps)" til "true". Dette gjør at den ansatte blir tvunget til å bytte passord når den skal logge inn for første gang. Vi har også sørget for at det ikke blir noen brukernavnkonflikter ved å implementere en funksjon som sjekker brukernavnet og eventuelt gjør noen endringer.

 
Ved et reelt oppsett av GPO'er i et domene ville vi brukt blant annet [Windows security baselines](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-security-baselines), som er annbefalt av Microsoft basert på tilbakemeldinger. i
  

Globale og lokale sikkerhetsgrupper / Gruppene i domenet: 
Vi har under prosjeket hatt [AGDLP](https://en.wikipedia.org/wiki/AGDLP) med oss ved opprettelse av grupper og utdeling av rettigheter. Ansattes rettigheter tildeles Domain Local gruppen G_Ansatt, samt at IT-avdelignen får Administratorettingheter ved å være medlem av den lokale gruppen'administrators'. De Globale gruppene inneholder brukere med samme behov, i dette tilfellet avdelinger. 


## Konklusjon
Vi er i hovedsak fornøyd med hvordan vi løste denne oppgaven, men scriptene våres har fortsatt noe forebdringspotensial. Vi ønsker blant annet å kunne kjøre alle scriptene fra klienten for å effektivisere driften av Active Directory. Vi hadde også styrket sikkerhetsaspektet betraktelig ved å hashe passordene og lagre disse i en database. Tatt dette i betraktning, så funker alle scriptene slik vi ønsker det, og en administrasjon vil kunne automatisere driften av alle prosessene med unntak av GPO.


### Av Andreas Finni Magnussen og Kristoffer Lie

