#Scriptet flytter SRV1 og Cl1 i riktig OUer, for å sikre maskinene. 


Get-ADComputer "srv1" | Move-ADObject -TargetPath "OU=Server,OU=Maskiner,DC=sec,DC=core" -Verbose
Get-ADComputer "cli1" | Move-ADObject -TargetPath "OU=C_Renhold,OU=Laptop,OU=Maskiner,DC=sec,DC=core" -Verbose

#eventuell kan vi lage  et script med fil, slik at vi kan automatisere prosessen