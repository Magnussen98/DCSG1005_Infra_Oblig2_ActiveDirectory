# AD-struktur Albegra-a2
[Link](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2) til GIT repo

## Mål med prosjektet
Microsoft sin hierarkiske katalogtjeneste, kalt [Active Directory](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview), gjør det mulig for en bedrift å [sentralisere alle brukere, maskiner og ressurser samtidig som at sikkerheten blir forsterket.](https://www.quest.com/solutions/active-directory/what-is-active-directory.aspx)I denne oppgaven har vi fått muligheten til utvikle våre kunnskaper om automatisering av drift ved bruk av Acitve Directory.  Vi har under hele prosjektperioden hatt sikkerhet i tankene, og har blant annet implemetert dette ved bruk av [Group Policy](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/policy/group-policy-objects). Dette prosjektet vil kunne gi oss mye relevant og ettertraktet kunnskap for arbeidsmarkedet i lang tid fremover. Vi har blant annet tatt for oss: 

1. Design av AD-Strukturen
2. Navnekonvensjon
3. Flere induviduelle script
3. Drøfting og refleksjon av vår løsning
4. Konklusjon

## Design
Vi har valgt å benytte oss av et design som er basert på [organisasjonen](https://www.serverbrain.org/infrastructure-design-2003/understanding-the-ou-design-options.html). [AD-strukturen](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/AD-Struktur.pdf) er inndelt slik at Ansatte, Ressurser og Maskiner (On-prem) har hver sin OU (Domain controller opprettes by default). Under ansatte ligger en Domain Local gruppe med hver avdelingsgruppe samt en OU pr. avdeling. Hver avdeling inneholder sine brukere, som ligger i den globale gruppen til avdelingen.

Ressursene i domenet er lagt i egen OU som Domain Local grupper. PCene (cl1 i vårt tilfelle) og serverne i AD-strukturen har hver sin OU under On-prem, samt en egen gruppe. Dette tillater å deligere spesifikke rettigheter til de ulike maskinene. 

## Navnekonvensjon 
Ved opprettelse av objekter i vårt domene har vi valgt å implementere en fast navnestandard. Det vil si at noen av objektene som opprettes får en fast prefiks bokstav etterfulgt av "_". F.eks. grupper får prefiks 'G_', etterfulgt av navnet. For OUer er 'U_' brukt for de som inneholder brukere (users). Alle GPO'er vi oppretter starter med 'GPO_' etterfulgt av navnet på OU'en den skal linkes til. 

## Forklaring av scriptene
Siden vi har valgt å lage flere script, så har vi valgt å lage en "[brukermanual](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/BrukerManual.md)" som forklarer hvilken rekkefølge scriptene skal kjøres i, og hvilken maskin scriptene skal kjøres fra. Dette har vi gjort for å sørge for at oppsettelse av AD strukturen skjer i riktig rekkefølge. Noen av scriptene benytter seg av en ".csv" fil som parameter. Dette har vi valgt å gjøre for å kunne automatisere prosessen til beste evne. Dette vil gjøre det enkelt for brukeren å benytte seg av scriptet igjen og igjen, selv om "variablene" endres.

## Drøfting
Vi har valgt å skrive mindre, men flere script som vil representere ulike oppgaver. Dette er fordi flere script vil sørge for [mer lesbar og organisert kode](https://softwareengineering.stackexchange.com/questions/401415/what-are-the-benefits-of-multi-file-programming) i stedet for ett langt script. Dette vil også gi oss muligheten til å kjøre induviduelle script på nytt dersom noe feilet. Vi har automatisert alle oppgavene som skulle gjøres med unntak av [GPO](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/policy/group-policy-objects). Et av våre hovedmål var å kunne automatisere hele prosessen, men vi fant fort ut at GPO ville bli for komplisert å automatisere. Derfor valgte vi å benytte GUI for opprettelse av GPO. Vi har dokumentert hvordan vi har implementert de ulike GPOene i en egen [fil](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/GPO.md). Videre så hadde vi et ønske om å kunne kjøre alle scriptene fra en klient, eller Cl1 i vårt tilfelle. I dagens samfunn så benytter de store bedriftene seg ofte av [multi-server environment](https://www.liquidweb.com/blog/is-splitting-off-resources-for-your-database-right-for-you/), som betyr flere servere. Derfor er det avgjørende for effektiviseringen av en Active Directory drift, å kunne benytte seg av "[invoke-command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-7.1)" for å implementere scriptene fra klienten. Dette medførte derimot noen problemer for oss. Derfor har vi nå tre script som kan kjøres fra klienten, men de resterende scriptene må kjøres fra enten Dc1 eller Srv1.

I "[Add-Users](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/AddUsers/Add-UsersV2.ps1)" scriptet har vi implementer flere sikkerhetsmekanismer. Vi benytter oss blant annet av en funksjon som generer et tilfeldig passord for hver bruker. Dette vil sørge for at alle de ansatte får et induviduelt default passord. Når en bruker blir lagt til i "add-users" scriptet så har vi også satt parameteren: "[changePasswordAtLogon](https://docs.microsoft.com/en-us/powershell/module/addsadministration/new-aduser?view=windowsserver2019-ps)" til "true". Dette gjør at den ansatte blir tvunget til å bytte passord når den skal logge inn for første gang.

En stor sikkerhetsrisiko med "Add-Users" scriptet er at vi lagrer brukernavnet og passordet i plaintekst på en fil på maskinen som oppretter brukerne. Dette har vi gjort for simplisiteten av denne oppgaven, slik at man kan se passordet og logge inn med riktig passord til de forskjellige brukerne. I virkligheten så ville vi selvfølgeig [hashet](https://accu.org/journals/overload/23/129/ignatchenko_2159/) passordene og lagret bruker akkrediteringen i en databse.


Vi har også sørget for at det ikke blir noen brukernavnkonflikter ved å implementere en funksjon som sjekker brukernavnet og eventuelt gjør noen endringer på brukernavnet. Det ønskelige brukernavnet er 3 bokstaver for fornavnet og 3 fra etternavnet. Vi brukte litt tid på å finne ut best practise på hvordan brukernavnet skulle bli endret dersom det allerede var i bruk. Vi tenkte først at et tre-sifret tall mellom fornavnsdelen og etternavnsdelen vill funke bra, men etter en telefonsamtale til dyktige ansatte i [vmware](https://www.vmware.com/no.html), fikk vi vite at veldig få ønsker et slikt brukernavn. Derfor benyttet vi oss av en annen løsning som først tar ekstra bokstaver fra fornavnet. Dersom fornavnet ikke har flere bosktaver, så vil etternavnet bli brukt mer. Dersom det oppstår en spesiell situasjon der det ikke er flere bokstaver igjen i fornavn eller etternavn, så vil brukernavnet få ett tall på slutten.

Vi har også opprettet [delte mapper](https://www.serverbrain.org/active-directory-planning-008/shared-folder-objects.html) som hver avdeling skal ha tilgang til. Alle brukerne vil da få tilgang til sin egen mappe, hvor den kan dele filer med andre kollegaer innenfor den samme avdelingen. Vi har også valgt å ha en "Public" mappe som er åpen for alle ansatte.

 
Ved et reelt oppsett av GPO'er i et domene ville vi brukt blant annet [Windows security baselines](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-security-baselines), som er annbefalt av Microsoft basert på tilbakemeldinger.
  

Globale og lokale sikkerhetsgrupper / Gruppene i domenet: 
Vi har under prosjeket hatt [AGDLP](https://en.wikipedia.org/wiki/AGDLP) med oss ved opprettelse av grupper og utdeling av rettigheter. Ansattes rettigheter tildeles Domain Local gruppen G_Ansatt, samt at IT-avdelignen får Administratorettingheter ved å være medlem av den lokale gruppen'administrators'. De Globale gruppene inneholder brukere med samme behov, i dette tilfellet avdelinger. 


## Konklusjon
Vi er i hovedsak fornøyd med hvordan vi løste denne oppgaven, men scriptene våres har fortsatt noe forebdringspotensial. Vi ønsker blant annet å kunne kjøre alle scriptene fra klienten for å effektivisere driften av Active Directory. Vi hadde også styrket sikkerhetsaspektet betraktelig ved å hashe passordene og lagre disse i en database. Tatt dette i betraktning, så funker alle scriptene slik vi ønsker det, og en administrasjon vil kunne automatisere driften av alle prosessene med unntak av GPO.