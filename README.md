# Azure Storage Container
VSTS release task for creating azure storage container with a defined public access level inside an existing storage account.

## How to use

1. Install the task in your VSTS account by navigating to the marketplace and click install. Select the VSTS account where the task will be deployed to.
 
2. Add the task to your release by clicking in your release on add a task and select the Utility category. Click the Add button on the Azure Storage Container task.
 
3. Configure the task. 
 ![alt tag](https://github.com/carlosjdelgado/AzureStorageContainer/blob/master/Screenshots/readme-image.png)
- Select an AzureRM subscription.
- Select the storage account where you want to create the container
- Set a name for the new container
- Select a public access level for the container. Default level is Off but you can set public access for blob or set public access for blob and container.

4. When you run the release, the storage container will be created.
