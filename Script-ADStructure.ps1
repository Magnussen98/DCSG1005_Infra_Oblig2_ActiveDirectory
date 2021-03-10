
#Oppretter hoved OU under Sec.core
New-ADOrganizationalUnit "Ansatt" -Description "Ansatt OU" 
New-ADOrganizationalUnit "Maskiner" -Description "Maskiner OU"


#variabler som henter ut "identity" til Ansatt og Maskin
$idAnsatt = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Ansatt"}).DistinguishedName
$idMaskiner = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Maskiner"}).DistinguishedName

#Oppretter OU under Ansatt
New-ADOrganizationalUnit "IT-admin" -Description "IT-admin OU" -Path $idAnsatt
New-ADOrganizationalUnit "HR" -Description "HR OU" -Path $idAnsatt
New-ADOrganizationalUnit "Developers" -Description "Developers OU" -Path $idAnsatt
New-ADOrganizationalUnit "Regnskap" -Description "Regnskap OU" -Path $idAnsatt
New-ADOrganizationalUnit "Renhold" -Description "Renhold OU" -Path $idAnsatt

#oppretter OU under Maskiner
New-ADOrganizationalUnit "IT-admin.m" -Description "IT-admin maskin OU" -Path $idMaskiner
New-ADOrganizationalUnit "HR.m" -Description "HR maskin OU" -Path $idMaskiner
New-ADOrganizationalUnit "Developers.m" -Description "Developers maskin OU" -Path $idMaskiner
New-ADOrganizationalUnit "Regnskap.m" -Description "Regnskap maskin OU" -Path $idMaskiner
New-ADOrganizationalUnit "Renhold.m" -Description "Renhold maskin OU" -Path $idMaskiner

#henter ut DistinguishedName in i en variabel:
$idIT = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "IT-admin"}).DistinguishedName
$idHR = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "HR"}).DistinguishedName
$idDevelopers = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Developers"}).DistinguishedName
$idRegnskap = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Regnskap"}).DistinguishedName
$idRenhold = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Renhold"}).DistinguishedName

#henter ut DistinguishedName in i en variabel:
$idITm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "IT-admin.m"}).DistinguishedName
$idHRm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "HR.m"}).DistinguishedName
$idDevelopersm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Developers.m"}).DistinguishedName
$idRegnskapm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Regnskap.m"}).DistinguishedName
$idRenholdm = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "Renhold.m"}).DistinguishedName

#Oppretter tilsvarende grupper for Ansatte
New-ADGroup -GroupCategory Security -GroupScope Global -Name "IT.g" -Path $idIT -SamAccountName "IT-admin.g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "HR.g" -Path $idHR -SamAccountName "HR.g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Developers.g" -Path $idDevelopers -SamAccountName "Developers.g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Regnskap.g" -Path $idRegnskap -SamAccountName "Regnskap.g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Renhold.g" -Path $idRenhold -SamAccountName "Renhold.g"

#Oppretter tilsvarende grupper for Maskiner
New-ADGroup -GroupCategory Security -GroupScope Global -Name "IT.m.g" -Path $idITm -SamAccountName "IT-admin.m.g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "HR.m.g" -Path $idHRm -SamAccountName "HR.m.g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Developers.m.g" -Path $idDevelopersm -SamAccountName "Developers.m.g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Regnskap.m.g" -Path $idRegnskapm -SamAccountName "Regnskap.m.g"
New-ADGroup -GroupCategory Security -GroupScope Global -Name "Renhold.m.g" -Path $idRenholdm -SamAccountName "Renhold.m.g"


$idHR = (Get-ADOrganizationalUnit -filter * | Where-Object{$_.name -eq "HR"}).DistinguishedName
