# Module 1: Azure management tools

### Lab D: Delete Azure resources

In this lab, you will delete the VMs you created in the previous two labs by deleting the resource groups to which they belong. Deleting a resource group deletes all the Azure resources inside it, including VMs, VNets, NSGs, IP addresses and storage accounts. Once deleted, a resource group can't be recovered, so before you delete any resource group in Azure, be certain that you don't need it any more.

```
Perform the exercises in this lab in the Windows Server 2016 VM that you created in Module 1, Lab A.
```

## Exercise 1 - Delete the first resource group

1. Browse to the Azure portal at http://portal.azure.com.

1. Click **Resource groups** in the menu on the left side of the page to list the resource groups that you have created.

1. Find the resource group named **armvm2RG**. This is the resource group that you created when you ran the PowerShell script in Module 1, Lab B.

1. Click the ellipsis (the three dots) on the right end of the row and select **Delete resource group** from the ensuing menu.

1. Type the resource-group name into the box labeled TYPE THE RESOURCE GROUP NAME. Then click the **Delete** button at the bottom of the blade.

	![Deleting a resource group](Images/delete-resource-group.png)

## Exercise 2 - Delete the second resource group

1. Return to the resource-groups blade and find the resource group named **mod1c-LabRG**. This is the resource group that you created in Module 1, Lab C.

1. Repeat Steps 4 and 5 in the previous exercise to delete the **mod1c-LabRG** resource group.

Once the resource groups are deleted, you will incur no more charges for them.