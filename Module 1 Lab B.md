# Module 1: Azure management tools

### Lab B: Create a VM using Azure PowerShell

In the previous lab, you used the Azure Portal to create an Azure virtual machine running Windows Server 2016. In this lab, you will use [PowerShell](https://docs.microsoft.com/powershell/scripting/overview?view=powershell-6) in that VM to create another Azure VM. PowerShell is an indispensable tool to Azure administrators because it offers an easy easy way to script and automate repetitive tasks. It also works on Windows, Linux, and macOS.

```
Perform the exercises in this lab in the Windows Server 2016 VM that you created in Module 1, Lab A.
```

![](Images/powershell-ise.png)

## Exercise 1 - Install Azure PowerShell modules

In this exercise, you will install the PowerShell [AzureRM](https://www.powershellgallery.com/packages/AzureRM/6.13.1) module in the Windows Server 2016 VM. This module adds commands (cmdlets) for working with the Azure Resource Manager (RM) to PowerShell.

1. Click **Start**, and in the Start menu, right-click **Windows PowerShell**. Select **More**, and then click **Run as administrator** to start PowerShell as an administrator. Click **Yes** in the User Account Control (UAC) popup.

1. In the PowerShell console, set the execution policy to "Unrestricted" by executing the following command:

	```powershell
	Set-ExecutionPolicy -ExecutionPolicy Unrestricted
	```

	When prompted for confirmation, select **Yes to All**.

	> Setting the ExecutionPolicy to Unrestricted can be detrimental to overall security. This won't cause any issues during training, but avoid doing this in a production environment.

1. In the PowerShell console, execute the following command:

	```powershell
	Install-Module -Name AzureRM -AllowClobber
	```

	Respond with **Yes** when asked if you want PowerShellGet to install and import the NuGet provider, and **Yes to All** when asked if you're sure you want to install modules from PSGallery.

1. Now execute this command:

	```powershell
	Import-Module AzureRM
	```

	If prompted about an "Untrusted publisher," respond with **Always run**.

1. In the PowerShell console, execute the following command. When prompted, provide the user name and password for your Microsoft account:

	```powershell
	Connect-AzureRmAccount
	```

1. Use the following command to list the Azure subscriptions associated with your Microsoft account:

	```powershell
	Get-AzureRmSubscription
	```

1. If more than one subscription is listed, pick the one you want to use for this lab and use the following command to make it the default subscription, replacing `<SubscriptionName>` with the name of the subscription:

	```powershell
    Select-AzureRmSubscription -SubscriptionName '<SubscriptionName>'
	```

1. Minimize the PowerShell console.

## Exercise 2 - Use the PowerShell ISE to manage Azure Objects

The [PowerShell Integrated Scripting Environment](https://docs.microsoft.com/powershell/scripting/components/ise/introducing-the-windows-powershell-ise?view=powershell-6) (ISE) provides an interactive environment for running, testing, and debugging PowerShell scripts. In this exercise, you will run a script in the PowerShell ISE to create a virtual machine.

### Task 1: Connect to your Azure subscription in the PowerShell ISE

1. Right-click the Windows PowerShell icon in the task bar at the bottom of the desktop and select **Run ISE as administrator** from the context menu. Click **Yes** in the UAC popup.

1. In the ISE command window (the dark blue area), list all available Azure PowerShell modules by running the following cmdlet:

	```powershell
	Get-Module -ListAvailable -Name Azure
	```

1. Sign in to Azure with the Microsoft account that is the Service Administrator of your Azure subscription by running the following Azure PowerShell cmdlet:

	```powershell
	Add-AzureRmAccount
	```

### Task 2: Use Azure PowerShell cmdlets

1. In the ISE, retrieve the list of subscriptions associated with your Microsoft account by running the following cmdlet:

	```powershell
	Get-AzureRmSubscription
	```

1. If more than one subscription is listed, pick the one you want to use for this lab and use the following command to make it the default subscription, replacing `<SubscriptionId>` with the ID of the subscription:

	```powershell
	Select-AzureRmSubscription -SubscriptionId <SubscriptionId>
	```

1. List the types of Azure Resource Manager resources you can create in your subscription by running the following cmdlet:

	```powershell
	Get-AzureRmResourceProvider
	```

	This cmdlet lists each Azure resource provider, its registration state (the provider must be registered before you can use it), and the resource types you can create using that provider.

1. List the resources that are implemented by the `Microsoft.Compute` resource provider (which includes Azure Virtual Machines) by running the following cmdlet:

	```powershell
	Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute
	```

1. List the resources that are implemented by the `Microsoft.Compute` resource provider in the East US Azure region by running the following cmdlet:

	```powershell
	Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute -Location 'East US'
	```

### Task 3. Use a PowerShell script to create a VM

1.  In the ISE command window, set the execution policy to "Unrestricted" by running the following cmdlet:

	```powershell
	Set-ExecutionPolicy -ExecutionPolicy Unrestricted
	```

	When prompted for confirmation, select **Yes to All**.

1. [Click here](https://a4r.blob.core.windows.net/public/az-scripts.zip) to download a zip file containing a collection of scripts used in this lab and others. Copy the contents of the zip file to a local folder in the VM — for example, to "My Documents\Scripts." 

1. In the PowerShell ISE, use the **File -> Open** command to open the script file named **Mod1_PS_ArmVM.ps1**, which you copied from the zip file in the previous step.

1. In the script, replace `<your_subscription_name>` on line 4 with the name of the subscription that you wish to use to create a VM.

1. Save the edited script. Then run it by clicking the green arrow in the toolbar at the top of the ISE or pressing **F5**. When prompted, sign in using your Microsoft account credentials.

1. Wait for the script to finish. It can take up to 10 to 15 minutes. Ignore any warnings saying that the output from a cmdlet will change in a future release.

1. When the script finishes, go to the [Azure portal](https://portal.azure.com) in your browser. Open the resource group named **armvm2RG** and confirm that it contains a virtual machine named **armvm2**. This is the virtual machine that the script created.

Finish up by stopping the **armvm2** virtual machine so you're not charged for it when it is not being used.
