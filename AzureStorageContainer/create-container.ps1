[CmdletBinding()]
param
(
    [string] [Parameter(Mandatory = $true)]
    $ConnectedServiceName,

    [string] [Parameter(Mandatory = $true)]
    $StorageName,

    [string] [Parameter(Mandatory = $true)]
    $ContainerName,

    [string] [Parameter(Mandatory = $true)]
    $ContainerPublicAccessLevel
)

import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

try 
{
    Write-Verbose "Getting Resource group name"
    $ResourceGroupName = Get-AzureRmStorageAccount | Where-Object {$_.StorageAccountName -eq $StorageName} | Select-Object -ExpandProperty ResourceGroupName
    Write-Verbose "Resource group name: $ResourceGroupName"
    
    Write-Verbose "Getting Storage key for storage $StorageName and resource group $ResourceGroupName"
    $StorageKey = (Get-AzureRmStorageAccountKey -AccountName $StorageName -ResourceGroupName $ResourceGroupName ).Value[0]
    Write-Verbose "Storage key: $StorageKey"
    
    Write-Verbose "Getting Storage context..."
    $StorageContext = New-AzureStorageContext -StorageAccountName $StorageName -StorageAccountKey $StorageKey

    Write-Host "Creating container $ContainerName in storage account $StorageName"
    New-AzureStorageContainer -Name $ContainerName -Context $StorageContext -Permission $ContainerPublicAccessLevel -ErrorAction Stop
    Write-Host "Succesfully created container $ContainerName in storage account $StorageName"
}
catch 
{
    Write-Host $_.Exception.ToString()
    throw
}
