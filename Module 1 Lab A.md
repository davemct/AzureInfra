# Module 1: Azure management tools

### Lab A: Create a virtual machine using the Azure portal

In this lab, you will create a virtual machine that you will use for most of the labs in this course. Then you will connect to the virtual machine using the [Remote Desktop Protocol](https://docs.microsoft.com/windows/desktop/TermServ/remote-desktop-protocol) (RDP). Note that the first time you sign in to the Azure portal, you will be asked whether you want to make the Home page or Dashboard your preferred view. You can choose either, but the rest of the labs are written with the assumption that the Dashboard is used.

![](Images/create-vm.png)

## Prerequisites

The following are required to complete this hands-on lab and the other labs in this course:

- An active Microsoft Azure subscription. If you don't have one, [sign up for a free trial](http://aka.ms/WATK-FreeTrial).
- A laptop running Windows 10 or any operating system that supports [Remote Desktop Connection](https://support.microsoft.com/help/17463/windows-7-connect-to-another-computer-remote-desktop-connection)

## Exercise 1 - Create an Azure virtual machine

In this exercise, you will use the Azure portal to create a virtual machine with two virtual CPUs, 8 GB of RAM, and a 16 GB SSD drive running Windows Server 2016. And you will configure it so that it can be remoted into from your local computer using RDP. 

1. In your browser, navigate to the Azure portal at https://portal.azure.com.

1. When prompted, sign in using the Microsoft account that is the Service Administrator of your Azure subscription.

1. In the menu on the left side of the portal, click **+ Create a resource**. This will bring up a blade containing lists titled "Azure Marketplace" and "Popular."

1. In the "Popular" list, if there is a hyperlink titled **Windows Server 2016 VM**, click it. Otherwise, type "Windows Server 2016 Datacenter" into the search box at the top of the blade and press **Enter**. In the ensuing blade, select **Windows Server 2016 Datacenter**.

1. In the "Create a virtual machine" blade, note the tabs along the top of the page. The first tab is the "Basics" tab. In this tab, enter the following settings:

	- Subscription: Select your subscription
	- Resource group: Click **Create new** and create a new resource group named **Main-Lab-RG**
	- Virtual machine name: **Main-Lab-vm1**
	- Region: Select an Azure region where you have the ability to provision Azure VMs. If in doubt, choose **East US**.
	- Availability options: default
	- Image: **Windows Server 2016 Datacenter**
	- Size: Click **Change Size** and select **B2ms**
	- Username: **Student**
	- Password: **Pa55w.rd1234**
	- Confirm password: **Pa55w.rd1234**
	- Under **Public inbound ports**, select **Allow selected ports**
	- Under  **Select inbound ports**, check the **RDP (3389)** box
	- Already have a Windows Server license: **No**

1. Click the **Next : Disks >** button at the bottom of the page.

1. On the "Disks" tab, review the settings but make no changes. Then click the **Next : Networking >** button.

1. On the "Networking" tab, inspect the default settings but make no changes. Then click the **Next : Management >** button.

1. Turn **OS guest diagnostics** on and accept the defaults everywhere else. Then click the **Next : Guest config >** button.

1. Review the settings, but make no changes. Then click the **Next : Tags >** button.

1. Here, you can add key-value pairs to further describe the virtual machine. These tags can appear in billing reports and help you identify costs. Do not make changes. Instead, click the **Next : Review + create >** button.

1. In the "Review + create" tab, confirm that the message "Validation passed" appears. Note also the pricing per hour for the virtual machine. Review these settings, and then click the **Create** button to begin deploying the virtual machine.

	> At the bottom of the page, there is a **Download a template for automation** link. This lets you downloads scripts for recreating the virtual machine without having to go back to the portal and enter every setting again. The scripts can also be modified to customize newly created VMs and are a handy automation tool for Azure administrators.

It typically takes 5 to 10 minutes to create a virtual machine. Wait for yours to be created, and then go to the Dashboard. If the Dashboard does not refresh with the new resources showing, refresh the page in the browser.

## Exercise 2 - Remote in to the virtual machine

In this exercise, you will use RDP to remote into the virtual machine and tweak the security settings in the VM's copy of Internet Explorer to allow easy access to the Azure portal from within the VM.

1. In the menu on the left side of the Azure portal, select **Resource groups**. Click **Main-Lab-RG** to open the resource group containing the resources created in the previous exercise.

1. Click **Main-Lab-vm1**, which is the virtual-machine resource. Then click the **Connect** button at the top of the blade.

1. In the "Connect to virtual machine" blade, click the **Download RDP File** button. Save the file in your computer's "Downloads" folder as **Main-Lab-VM1.rdp**. Then open the file.

1. In the **Remote Desktop Connection** window, click **Connect**.

1. When prompted for login credentials, click **More choices** followed by **Use a different account**. Then enter the user name and password you specified for the VM in the previous exercise and click the **OK** button.

1. If you are warned that the remote computer could not be authenticated and asked if you want to connect anyway, answer **Yes**.

1. After the Windows Server 2016 desktop loads, go to the Server Manager. In the hub menu of Server Manager, select **Local Computer**. Note the settings, including the IP address and computer name.

1. Under "IE Security Enhanced Configuration," click **On**. In the ensuing popup, go to the "Administrators" area and select the **Off** radio button. Then click **OK**. This will allow you to get to the Azure Portal and other sites without adding secured zone pages.

9.  Open Internet Explorer in the VM and navigate to the Azure portal at https://portal.azure.com.

10. When prompted, sign in to the portal using the Microsoft account that is the Service Administrator of your Azure subscription.

11. Remain signed in. You will use the **Main-Lab-VM1** virtual machine for all but two of the remaining labs.

## Important post-lab notes

You are charged for VMs even when they're not being used. The B2ms virtual machine size is relatively expensive, and a typical Azure Pass (if that's the type of subscription you're using) will reach its limit if this VM is left running for several days or a few weeks. You can stop a VM to reduce the charges to a trickle, or delete it to eliminate additional charges altogether. However, for this course, you will not delete it until you're finished.

To minimize charges to your Azure subscription, you should stop **Main-Lab-VM1** at the end of each day, and whenever you plan to be away from it for more than an hour or two.

**To stop the virtual machine:**

1.  Close the **Main-Lab-VM1** RDP window.

1.  In the Azure portal, click **Stop** at the top of the blade for the VM. Then click **Yes** when prompted for confirmation.

To restart the VM and connect to it again, return to the blade for the VM in the Azure portal and click **Start** at the top of the blade. Wait for the VM to start. Then click **Connect** and sign in to the VM again. Note that the VM will have a different IP address than it had before. The VM is assigned a new IP address each time it is started.