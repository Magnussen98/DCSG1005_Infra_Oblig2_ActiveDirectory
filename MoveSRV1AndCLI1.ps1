#Scriptet flytter SRV1 og Cl1 i riktig OUer, for å sikre maskinene. 


Get-ADComputer "SRV1" | Move-ADObject -TargetPath "OU=Server,DC=sec,DC=core" 
Get-ADComputer "CL1" | Move-ADObject -TargetPath "OU=PC,DC=sec,DC=core" 

#eventuell kan vi lage  et script med fil, slik at vi kan automatisere prosessen