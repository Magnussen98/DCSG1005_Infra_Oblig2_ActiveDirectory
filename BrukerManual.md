Dette dokumentet vil forklare hvordan rekkefølge de ulike scriptene skal kjøres samtidig som hvor scriptene skal kjøres fra. Scriptene inkludert er:

1. [ScriptADOrganizationUnit.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/OU/ScriptADOrganizationUnit.ps1)
2. [ScriptADGroups.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/Groups/ScriptADGroups.ps1)
3. [Add-UsersV2.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/AddUsers/Add-UsersV2.ps1)
4. [Check-UserCreation.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/AddUsers/Check-UserCreation.ps1)
5. [Organize-GroupsAndComputers.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/Organize/Organize-GroupsAndComputers.ps1)
6. [ScriptSMBshare.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/Share/ScriptSMBshare.ps1)
7. [Install-IIS.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/IIS/Install-IIS.ps1)

## OU Struktur
Det første scriptet som skal kjøres er: [ScriptADOrganizationUnit.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/OU/ScriptADOrganizationUnit.ps1)

Dette scriptet skal kjøres på: Cl1
Scriptet oppretter OU strukturen til domenet.

## Gruppe Struktur
Det neste scriptet som skal kjøres er: [ScriptADGroups.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/Groups/ScriptADGroups.ps1)
Dette scriptet skal kjøres på: Cl1

Dette scriptet oppretter gruppe strukturen. Det vil bli opprettet både globale grupper, som maskiner og brukere skal bli lagt i, og lokale grupper som kommer til å ha spesifikke globale grupper som medlem. De lokale gruppene vil ha aksesskontroll for resursser i bedriften.

## Brukeropprettelse
Det tredje scriptet som skal kjøres er [Add-UsersV2.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/AddUsers/Add-UsersV2.ps1)
Dette scriptet skal kjøres på: DC1

Dette scriptet vil opprette brukere, og legge disse brukerne inn i de riktige OUene i domenet.

## Sjekk brukeropprettelse i sikkerhetsloggen
Scriptet [Check-UserCreation.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/AddUsers/Check-UserCreation.ps1) blir kalt automatisk fra add-users scriptet. Derfor er det vitkig å være i samme mappe som begge scriptene når add-users blir kjørt.

Dette scriptet vil sjekke sikkerhets loggen for å sjekke at det har blitt opprettet like mange brukere som var planlagt.

## Organisering av grupper, brukere og maskiner
Det femte scriptet som skal kjøres er: [Organize-GroupsAndComputers.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/Organize/Organize-GroupsAndComputers.ps1)
Dette scriptet skal kjøres fra: DC1

Dette scriptet legger alle brukerne og maskinene inn i de riktige globale gruppene. Maskinene vil også bli flyttet fra computers containeren og inn i riktig OU. De globale gruppene vil også bli lagt inn i de riktig lokale gruppene for å kunne implementere aksesskontrol.

## Opprettelse av share
Det 6. scriptet er: [ScriptSMBshare.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/Share/ScriptSMBshare.ps1)
Dette scriptet må kjøres fra: Srv1

Dette scriptet oppretter delte mapper og knytter disse mappene til domenet. Disse mappene blir også knyttet opp til de spesifikke avdelingene, som gjør at brukerne innenfor disse avdelingene er de eneste som kan aksessere mappen.

## Installering av IIS
Det 7. scriptet er: [Install-IIS.ps1](https://gitlab.stud.idi.ntnu.no/andrefm/albegra-a2/-/blob/master/Scripts/IIS/Install-IIS.ps1)
Dette scriptet skal kjøres på: Cl1

Dette scriptet innstallerer "web-server" på Srv1 og laster ned en [template](https://www.free-css.com/free-css-templates) som blir brukt som nettsiden til srv1.
