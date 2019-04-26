# Module 3: Integrating with Azure Compute Services

### Lab B: Moving containers between on-premises virtual machines and Azure virtual machines

In this lab, you will learn how to migrate apps that run on-premises in Docker containers to Azure so that they run in Docker containers in the cloud.

## Preinstallation steps

For this lab, you will use a more powerful VM than the one you used in previous labs. The new VM has four virtual CPUs, 16 GB of RAM, and a 32 GB SSD drive. It also supports [nested virtualization](https://azure.microsoft.com/blog/nested-virtualization-in-azure/), which is essential for the exercises in the lab.

Using the steps outlined in Module 1, Lab A, create a new Windows Server 2016 virtual machine named **Main-Lab3b-VM2** with the following changes:

- Place the VM in a new resource group named **Lab3b-RG**
- Set the VM size to **D4s v3**

Once the VM is deployed, remote into it and use it for the all of the remaining exercises in this lab.

## Exercise 1 - Create a Docker host

In this exercise, you will turn the VM into a Docker host by installing Docker.

### Task 1: Install Docker Enterprise Edition for Windows Server

1. Launch PowerShell **as an administrator**.

1. In the PowerShell console, execute the following commands:

	```powershell
	Set-ExecutionPolicy -ExecutionPolicy Unrestricted
	Install-WindowsFeature Hyper-V,Hyper-V-Tools,Hyper-V-PowerShell
	```

1. Now execute this command to restart the virtual machine:

	```powershell
	Restart-Computer
	```

1. Reconnect to the virtual machine. Launch PowerShell again as an administrator and execute the following commands:

	```powershell
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
	Install-Package -Name docker -ProviderName DockerMsftProvider -Force
	```

1. Restart the virtual machine again:

	```powershell
	Restart-Computer
	```

1. Reconnect to the virtual machine. Launch PowerShell again as an administrator and execute the following commands:

	```powershell
	Install-Package -Name docker -ProviderName DockerMsftProvider -Force
	Start-Service docker
	Start-Sleep 10
	Restart-Service docker
	```

### Task 2: Install Docker Toolbox for Windows

1. Open a browser and navigate to https://docs.docker.com/toolbox/toolbox_install_windows/. Click the **Get Docker Toolbox for Windows** button and follow the on-screen prompts to install Docker Toolbox for Windows. Accept the default options everywhere **except** for the following:

	- When asked which additional tasks should be performed, ensure that the **Install VirtualBox with NDIS5 driver** check box is NOT checked
	- When asked if you would like to install Oracle device software, answer no
	- In the final step of the installation wizard, uncheck the **View Shortcuts in File Explorer** box

1. Once Docker Toolbox for Windows is installed, navigate to https://github.com/docker/machine/releases/. Right-click **docker-machine-Windows-x86_64.exe** and save it to the "C:\\Program Files\Docker Toolbox" folder using the name **docker-machine.exe**, overwriting the existing file of that name.

1. Restart the VM, and then remote back in.

### Task 3: Create a Docker host in a Hyper-V virtual machine

1. Click the Windows **Start** button. Then click **Windows Administrative Tools**, and underneath that, click **Hyper-V Manager** to launch the Windows Hyper-V Manager.

1. In the Hyper-V Manager window, click the machine name (MAIN-LAB3B-VM2) in the treeview on the left. Then click **Virtual Switch Manager...** in the "Actions" pane.

1. Click the **Create Virtual Switch** button. In the ensuing dialog, name the switch "External Switch" and click **OK**.

1. Launch a Command Prompt window running as an administrator and execute the following command to provision a Hyper-V virtual machine:

	```
	docker-machine create --driver hyperv --hyperv-virtual-switch "External Switch" localdockervm
	```

5.  Wait for the new virtual machine to be provisioned.

You are now running a virtual machine inside a virtual machine. That's why you created an Azure VM that supports nested virtualization for this lab.

### Task 4: Create a Docker host in the Azure virtual machine

1. Open a browser in the VM and navigate to https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest.

1. Click the **Download the MSI installer** button to download the installer for the Azure CLI. Then run the installer. Accept any terms and conditions presented to you.

1. Restart the VM and then reconnect to it.

1. Launch a Command Prompt window running as an administrator and execute the following command:

	```
	az login
	```

	When prompted, sign in using your Microsoft account. 

1. Execute the following CLI command in the Command Prompt window to list all the Azure subscriptions associated with your Microsoft account:

	```
	az account show
	```

1. Copy the ID of the subscription that you wish to use to provision a Docker host in an Azure VM into your favorite text editor so you can easily retrieve it in a moment.

1. To identify Ubuntu images that you can use in this lab, execute the following command, replacing `<location>` with the name of the Azure region where you provisioned the VM you're running in:

	```
	az vm image list-skus --location "<location>" --publisher Canonical --offer UbuntuServer --output table
	```

	![Ubuntu images](Images/list-ubuntu-images.png)

1. Confirm that **16.04.0-LTS** appears in the list of Ubuntu images. If it doesn't, then pick another one and use it in place of **16.04.0-LTS** in Step 10.

1. Use the following command to change the current directory to the local user profile:

	```
	cd %USERPROFILE%
	```

12. To provision a Docker host in an Azure VM, execute the following command. Replace `<subscription_id>` with the Azure subscription ID you saved in Step 6, and `<location>` with the name of the Azure region where you provisioned the Azure VM you're running in:

	```
	docker-machine create --driver azure --azure-ssh-user student --azure-subscription-id "<subscription_id>" --azure-open-port 80 --azure-open-port 8080 --azure-image "Canonical:UbuntuServer:16.04.0-LTS:latest" --azure-location "<location>" --azure-resource-group "Lab3b-RG" --azure-size "Standard_A1" --azure-static-public-ip "lab3b-vm3b"
	```

1. Navigate to https://microsoft.com/devicelogin in your browser and enter the authentication code shown in the Command Prompt window. When prompted, enter your Microsoft account credentials.

1. Wait for provisioning to complete and confirm that it completed successfully. Then execute the following command:

	```
	docker-machine ls
	```

	Verify that the output includes both the Hyper-V virtual machine and the Azure VM.

1. Use the following command to configure the local shell environment:

	```
	@FOR /f "tokens=*" %i IN ('docker-machine env lab3b-vm3b') DO @%i
	```

### Task 5: Run a container in a Docker host in a Hyper-V virtual machine

1. Start Hyper-V Manager. Right-click **localdockervm** in the list of virtual machines and click **Connect**.

1. In the console for **localdockervm**, execute the following command:

	```docker
	docker run -d -p 80:80 --restart=always nginx
	```

	The ability to download the nginx image and connect to the nginx-based container depends on the availability of DHCP in the lab environment. Also, a firewall can prevent access to nginx. If **localdockervm** cannot get an IP Address from Azure DHCP, then this command will not work. If this occurs, proceed to Task 5.

1. Wait until the `nginx` container is started on the Docker host virtual machine. This might take a few minutes depending on the available bandwidth.

1. To obtain the IP address of the VM hosting the containerized application, execute the following command in the **localdockervm** console:

	```
	ifconfig eth0
	```

	Copy the IP address following **inet addr:** in the output to the clipboard.

1. Browse to the IP address you obtained in the previous step. Verify that the browser shows the "Welcome to nginx" page.

### Task 6: Run a container in a Docker host in an Azure virtual machine

1. Execute the following command in the Command Prompt window:

	```docker
	docker run -d -p 80:80 --restart=always nginx
	```

1. Use the following command to obtain the IP address of the Azure VM hosting the containerized application:

	```docker
	docker-machine ip lab3b-vm3b
	```

	Copy the IP address to the clipboard.

1. Browse to the IP address you obtained in the previous step. Verify that the browser shows the "Welcome to nginx" page.

Upon completion of this exercise, you have successfully installed Docker Toolbox for Windows, created a Docker host in a Hyper-V virtual machine by using Docker Machine, created a Docker host in an Azure virtual machine by using Docker Machine, and run a sample containerized web server nginx on both Docker host virtual machines.

## Exercise 2: Deploy a private Docker Registry in Azure

In this exercise, you will tk.

### Task 1: Create an Azure Container Registry

1.  On the host computer, start Internet Explorer.

2.  In Internet Explorer, browse to the Azure portal at http://portal.azure.com

3.  When prompted, sign in using the Microsoft account that is the Service Administrator of your Azure subscription.

4.  In the Azure portal, in the menu on the left hand side, click **+ Create a resource**.

5.  On the **New** blade, click **Containers**. Then click **Azure Container Registry**.

6.  On the **Create container registry** blade, specify the following settings and click **Create**:

	- Registry name: a unique name consisting of between 5 and 50 alphanumeric characters
	- Subscription: the name of the Azure subscription you are using in this lab
	- Resource group: click **Use existing** and, in the drop-down box, select **Main-Lab3b-RG**
	- Location: select any Azure location where you can create an Azure Container Registry, preferably the same one hosting the Azure VM you deployed earlier in this exercise
	- Admin user: **Enable**
	- SKU: **Basic**

	Enabling the admin-user option allows you to use the registry name as the user name and the access key as the password for logging in to the registry.

7.  Wait for the operation to complete.

### Task 2: Identify Azure Container Registry authentication settings

1.  On the host computer, in the Azure portal, click **All services**. Type **Container registries** into the **Filter** text box. Then, in the service menu, click **Container registries**.

2.  On the **Container registries** blade, click the Azure container registry you created in the previous task.

3.  On the container registry blade, click **Access keys**. Under **Admin user,** Click **Enable**.

4.  Click the **Click to copy** icon next to the **password** entry. If asked whether to allow the web page to access the clipboard, click **Allow access**.

5.  Note the values of the **Username** and **Login server** entries. The user name should match the registry name and the login server name should consist of the registry name followed by **.azurecr.io**.

### Task 3: Push an image to Azure Container Registry

1.  On the host computer, in the **Administrator: Command Prompt** window, use the following command to log in to the Azure Container registry you created in the first task, replacing `<user-name>`, `<password>`, and `<login-server>` with the values you identified in the previous task:

	```docker
	docker login --username <user-name> --password <password> <login-server>
	```

2.  Ensure that you receive a "Login succeeded" message. Next, to pull an existing image from Docker Hub to the Azure Docker VM, in the **Administrator: Command Prompt** window, execute the following command:

	```docker
	docker pull microsoft/aci-helloworld
	```

3.  Wait for the image to be downloaded to the Docker Azure VM. To tag the image with the Azure Container registry name, in the **Administrator: Command Prompt** window, execute the following command, replacing `<login-server>` with the value you identified in the previous task:

	```docker
	docker tag microsoft/aci-helloworld <login-server>/aci-helloworld:v1
	```

4.  Use the following command to push the tagged image to the Azure Container registry, replacing `<login-server>` with the value you identified in the previous task:

	```docker
	docker push <login-server>/aci-helloworld:v1
	```

5.  Wait for the image to be pushed to the registry. If you would like to view the images stored in the Azure Container registry, switch to the Internet Explorer window displaying the Azure portal, and on the container registry blade, click **Repositories**. Note that the list includes the **aci-helloworld** repository.

### Task 4: Download and deploy images from the Azure Container Registry

1.  On the host computer, in the **Administrator: Command Prompt** window, to pull an image from the Azure Container registry, execute the following command, replacing `<login-server>` with the value you identified earlier in this exercise:

	```docker
	docker pull <login-server>/aci-helloworld:v1
	```

2.  Note that, in this case, the image does not need to be downloaded, since the up-to-date version is already present on the target Docker Azure VM.

3.  Next, to deploy the image downloaded from the Azure Container registry, in the **Administrator: Command Prompt** window, execute the following command, replacing `<login-server>` with the value you identified earlier in this exercise:

	```docker
	docker run -d --restart=always -p 8080:80 <login-server>/aci-helloworld:v1
	```

4.  To verify that the image has been successfully deployed, in the **Administrator: Command Prompt** window, type the following, and then press Enter:

	```docker
	docker ps
	```

5.  Note that the output includes the aci-helloworld:v1 image.

6.  To access the running container, switch to the Internet Explorer window displaying the **Welcome to nginx!** page, append **:8080** directly after the IP address of the Azure VM appearing in the address bar, and then press Enter. Verify that you see the **Welcome to Azure Container Instances** page.

### Task 5: Delete the resource group

Finish up by deleting the **Lab3b-RG** resource group using the same procedure you used to delete resource groups in previous labs. You won't be using these resources again, so there is no need to keep them around and incur unnecessary charges to your Azure subscription.
