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
    $ContainerPublicAccessLevel,

    [string] [Parameter(Mandatory = $true)]
    $ContinueOnExistence
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
    
    Write-Verbose "Checking if task should be skipped when Container $ContainerName exists..."
    $ContinueOnExistence = Get-VstsInput -Name ContinueOnExistence
    Write-Verbose "Task will be skipped: $ContinueOnExistence"
    
    Write-Verbose "Checking if Container $ContainerName exists in storage $StorageName..."
    $TestContainer = Get-AzureStorageContainer -Context $StorageContext | Where-Object { $_.Name -eq $ContainerName }
    Write-Verbose "Container found: $ContainerName"

    if ($ContinueOnExistence -eq $true -and $TestContainer -ne $null)
    {
        Write-Host "Container $ContainerName already exists in storage account $StorageName"
    }
    else
    {
        Write-Host "Creating container $ContainerName in storage $StorageName"
        New-AzureStorageContainer -Name $ContainerName -Context $StorageContext -Permission $ContainerPublicAccessLevel -ErrorAction Stop
        Write-Host "Succesfully created container $ContainerName in storage account $StorageName"
    }
}
catch 
{
    Write-Host $_.Exception.ToString()
    throw
}
