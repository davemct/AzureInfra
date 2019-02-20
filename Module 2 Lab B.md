# Module 2: Azure Virtual Network service and components

### Lab B: Implementing a point-to-site VPN using Azure Resource Manager

In this lab, you will create a virtual network and a subnet to go with it. Then you will create a VPN gateway, configure it to support point-to-site VPN, and connect to it from an on-premises virtual machine.

```
Perform the exercises in this lab in the Windows Server 2016 VM that you created in Module 1, Lab A.
```

## Exercise 1 - Prepare a virtual network for point-to-site VPN

In this exercise, you will create a virtual network and add a gateway subnet to it.

### Task 1: Create an Azure virtual network

1. Navigate to the Azure portal at https://portal.azure.com. If prompted, sign in using the Microsoft account that is the Service Administrator of your Azure subscription.

1. Click **+ Create a resource** in the menu of the left side of the page. Then click **Networking**, followed by **Virtual Network**.

	![Creating a virtual network](Images/new-virtual-network.png)

1. Enter the following settings into the "Create virtual network" blade, and then click **Create**:

	- Name: **lab2b-vnet**
	- Address space: **10.3.0.0/20**
	- Subscription: Select your subscription
	- Resource group: Create a new resource group named **lab2b-RG**
	- Location: **US East**
	- Subnet name: **subnet-0**
	- Subnet address range: **10.3.0.0/24**
	- DDoS Protection: **Basic**
	- Service endpoints: **Disabled**
	- Firewall: **Disabled**

Wait for the VNet to be deployed before proceeding. Deployment should take less than a minute.

### Task 2: Create a gateway subnet

1. In the Azure portal, open the **lab2b-RG** resource group created in the previous task and click **lab2b-vnet**.

1. Click **Subnets** in the menu on the left side of the blade. Then click **+ Gateway subnet** at the top of the blade.

1. In the "Add subnet" blade, enter **10.3.15.224/27** as the address range. Then click **OK**.

	![Adding a subnet](Images/add-subnet.png)

## Exercise 2 - Configure point-to-site VPN

In this exercise, you will create a VPN gateway for the VNet created in the previous exercise. Then you will generate a pair of certificates and use them to configure the gateway for VPN access.

### Task 1: Create a VPN gateway

1. Click **+ Create a resource**, followed by **Networking** and then **Virtual network gateway**.

1. Enter the following settings and click **Create**:

	- Name: **lab2b-gw**
	- Gateway type: **VPN**
	- VPN type: **Route-based**
	- SKU: **VpnGw1**
	- Virtual network: **lab2b-vnet**
	- Public IP address: Make sure **Create new** is selected, and enter **lab2b-gw-ip**
	- Resource group: **lab2b-RG**
	- Location: **US East**

Do not wait for the gateway to be provisioned. Instead, proceed to the next task. The gateway can require up to 45 minutes to provision.

### Task 2: Generate root and client certificates

1. Launch the PowerShell ISE **as an administrator**.

1. Use the **File -> Open** command in the ISE to open the script file named **New-WINCOMP2SVPNCerts.ps1**, which you copied into a local folder in Module 1, Lab B.

1. Review the content of the script. The purpose of the script is to create two certificates. The first is a root certificate, which has a public key you will upload to Azure. The second is a client certificate that would need to be installed on every VPN client computer. The client certificate references the root certificate.

1. In the ISE's command window, execute the following command:

	```powershell
	Set-ExecutionPolicy -ExecutionPolicy Unrestricted
	```

	If prompted for confirmation, select **Yes to All**.

1. Execute the script by clicking the green arrow in the toolbar at the top of the ISE or pressing **F5**.

Note that only one thumbprint is returned. This is expected, even though two key pairs are created.

### Task 3: Export the private key of the client certificate

1.  Right-click the **Start** button on the desktop and select **Run**. Enter and execute the following command to launch Certificate Manager:

	```
	certmgr.msc
	```

1. In the Certificate Manager window, select **Personal -> Certificates** in the left pane. Right-click **wincomP2SChildCert** in the right pane and select **All Tasks -> Export...** from the context menu. This will launch the Certificate Export Wizard.

1. Click **Next**. Select **Yes, export the private key**, and then click **Next**.

1. Click **Next** to accept the default export-format options.

1.  On the Security page, check the **Password** box. Type **Pa55w.rd** into the "Password" and "Confirm password" fields. Then click **Next**

1. Enter the file name **C:\Client1Certificate.pfx**, and then click **Next**.

1. Click **Finish**. Then click **OK**.

1. Execute the following command in the command pane of the PowerShell ISE:

	```powershell
	Get-Item -Path 'C:\Client1Certificate.pfx'
	```

1. Verify that the file containing the private key of the client certificate was successfully created. Then close the Certificate Manager window.

### Task 4: Configure the Point-to-Site VPN gateway

1. Return to the Azure portal and the **lab2b-RG** resource group. Confirm that the gateway named **lab2b-gw** has been provisioned. If it hasn't, wait for provisioning to complete.

1. Click **lab2b-gw**.

1. Click **Point-to-site configuration** in the menu on the left side of the blade. Then click **Configure now**.

1. Enter the following settings:

	- Address pool: **10.255.255.0/24**
	- Tunnel type: **SSTP (SSL)**
	- Authentication type: **Azure certificate**
	- Root certificates: Type  **wincomLabP2SRootCert** into the NAME box

1. To retrieve the data for the root certificate, switch back to the PowerShell ISE and execute the following command:

	```powershell
	$rootCerText = Get-ChildItem -Path 'Cert:\CurrentUser\My' | Where-Object {$_.Subject -eq 'CN=wincomLabP2SRootCert'}
	```

	Note that no output is generated. This is expected.

1. To convert the certificate to Base64 format, execute the following command in the PowerShell ISE:

	```powershell
	$rootCertTextB64 = [System.Convert]::ToBase64String($rootCerText.RawData)
	```

	Once more, no output is generated. This is expected.

1. Now execute this command to copy the Base64 string to the clipboard:

	```powershell
	Set-Clipboard -Value $rootCertTextB64
	```

	No output is generated, but now the clipboard holds the 64-bit key value.

1. Paste the string that is on the clipboard into the PUBLIC CERTIFICATE DATA box in the Azure portal.

1. Click **Save** at the top of the blade and wait for the settings to be saved. This process might take several minutes.

Upon completing this exercise, you have created a point-to-site VPN gateway, generated self-signed root and client certificates, exported the public key of the root certificate, exported the private key of the client certificate, and configured the gateway to use the root certificate.

## Exercise 3 - Test a point-to-site VPN from a virtual machine

In this exercise, you will use the VPN gateway to connect to the VNet you created in Exercise 1.

### Task 1: Download and install the VPN client configuration package

1. In the "Point-to-site configuration" blade in the Azure portal, click **Download VPN client**. Then open the folder containing the downloaded file.

1. Open the zip file named  **lab2b-gw.zip** and run the file named **VpnClientSetupAmd64.exe** in the zip file's "WindowsAmd64" folder. If a security window pops up saying "Won't run," click **More info** and then click **Run Anyway**.

1. When asked whether you want to install a VPN Client for **lab2b-vnet**, answer **Yes**.

1. Wait for the installation to complete. This should take less than a minute.

### Task 2: Establish a point-to-site VPN from the virtual machine

1. Click the **Start** button on the desktop in the VM, and then click **Settings**.

1. In the Settings app, click **Network & Internet**.

1. Click **VPN**.

1. Click **lab2b-vnet**, and then click **Connect**.

1. In the **lab2b-vnet** window, click **Connect**. Click **Continue** when you are prompted to elevate the privilege for Connection Manager.

1. Once you're connected, execute the following command in the PowerShell ISE:

	```powershell
	Get-NetIPConfiguration
	```

	This cmdlet returns the computer's IP configuration. Notice the IPv4 address entry for the **lab2b-vnet** interface alias. Confirm that it shows an IP address from the VPN client IP address pool: 10.255.255.0/24.

1. Return to the Settings app. On the "VPN" tab, click **lab2b-vnet**. Click **Disconnect**, followed by **Remove**. Then close the window.

### Task 3: Delete the resource group

Finish up by deleting the **lab2b-RG** resource group using the same procedure you used to delete resource groups in previous labs. You won't be using these resources again, so there is no need to keep them around and incur unnecessary charges to your Azure subscription.
