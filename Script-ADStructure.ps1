
#Oppretter hoved OU under Sec.core
New-ADOrganizationalUnit "Ansatt" -Description "Ansatt OU" 
New-ADOrganizationalUnit "Maskiner" -Description "Maskiner OU"


#variabler som henter ut "identity" til Ansatt og Maskin
$idAnsatt = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Ansatt"}).DistinguishedName
$idMaskiner = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Maskiner"}).DistinguishedName

#Oppretter OU under Ansatt
New-ADOrganizationalUnit "U_IT-admin" -Description "IT-admin OU" -Path $idAnsatt
New-ADOrganizationalUnit "U_HR" -Description "HR OU" -Path $idAnsatt
New-ADOrganizationalUnit "U_Developers" -Description "Developers OU" -Path $idAnsatt
New-ADOrganizationalUnit "U_Regnskap" -Description "Regnskap OU" -Path $idAnsatt
New-ADOrganizationalUnit "U_Renhold" -Description "Renhold OU" -Path $idAnsatt

#oppretter OU under Maskiner
New-ADOrganizationalUnit "Laptop" -Description "Laptop maskiner OU" -Path $idMaskiner
New-ADOrganizationalUnit "Arbeidsstasjoner" -Description "Arbeidstasjoner OU" -Path $idMaskiner
New-ADOrganizationalUnit "Skrivere" -Description "Developers maskin OU" -Path $idMaskiner

#henter ut DistinguishedName for Laptop, arbeidstasjoner og printer
$idLaptop = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Laptop"}).DistinguishedName
$idArbeidsstasjon = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Arbeidsstasjoner"}).DistinguishedName
$idSkrivere = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Skrivere"}).DistinguishedName

#Oppretter OU under Laptop
New-ADOrganizationalUnit "C_IT-admin" -Description "IT-admin maskin OU" -Path $idLaptop
New-ADOrganizationalUnit "C_HR" -Description "HR maskin OU" -Path $idLaptop
New-ADOrganizationalUnit "C_Developers" -Description "Developers maskin OU" -Path $idLaptop
New-ADOrganizationalUnit "C_Regnskap" -Description "Regnskap maskin OU" -Path $idLaptop
New-ADOrganizationalUnit "C_Renhold" -Description "Renhold maskin OU" -Path $idLaptop

#henter ut DistinguishedName in i en variabel:
$idIT = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "U_IT-admin"}).DistinguishedName
$idHR = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "U_HR"}).DistinguishedName
$idDevelopers = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "U_Developers"}).DistinguishedName
$idRegnskap = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "U_Regnskap"}).DistinguishedName
$idRenhold = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "U_Renhold"}).DistinguishedName

#henter ut DistinguishedName in i en variabel:
$idITm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "C_IT-admin"}).DistinguishedName
$idHRm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "C_HR"}).DistinguishedName
$idDevelopersm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "C_Developers"}).DistinguishedName
$idRegnskapm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "C_Regnskap"}).DistinguishedName
$idRenholdm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "C_Renhold"}).DistinguishedName

#Oppretter tilsvarende grupper for Ansatte
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Ansatt_g" -Path $idAnsatt -SamAccountName "Ansatt_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "U_IT-admin_g" -Path $idIT -SamAccountName "IT-admin_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "U_HR_g" -Path $idHR -SamAccountName "HR_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "U_Developers_g" -Path $idDevelopers -SamAccountName "Developers_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "U_Regnskap_g" -Path $idRegnskap -SamAccountName "Regnskap_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "U_Renhold_g" -Path $idRenhold -SamAccountName "Renhold_g"

#Oppretter tilsvarende grupper for Maskiner
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Maskiner_g" -Path $idMaskiner -SamAccountName "Maskiner_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Arbeidssatsjon_g" -Path $idArbeidsstasjon -SamAccountName "Arbeidssatsjon_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Laptop_g" -Path $idLaptop -SamAccountName "Laptop_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Skriver_g" -Path $idSkrivere -SamAccountName "Skriver_g"

New-ADGroup -GroupCategory Security -GroupScope Global -Name "C_IT-admin_g" -Path $idITm -SamAccountName "c_IT-admin_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "C_HR_g" -Path $idHRm -SamAccountName "C_HR_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "C_Developers_g" -Path $idDevelopersm -SamAccountName "C_Developers_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "C_Regnskap_g" -Path $idRegnskapm -SamAccountName "C_Regnskap_g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "C_Renhold_g" -Path $idRenholdm -SamAccountName "C_Renhold_g"

