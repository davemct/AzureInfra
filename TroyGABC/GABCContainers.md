# Module 3: Integrating with Azure Compute Services

### Lab B: Moving containers between on-premises virtual machines and Azure virtual machines

In this lab, you will learn how to migrate apps that run on-premises in Docker containers to Azure so that they run in Docker containers in the cloud.

## Exercise 1, Create and prepare VM for Lab 3B

### Task 1, Create the Windows Server 2016 Datacenter with Containers virtual machine

1. Using the steps outlined in Module 1, Lab A, create a new Windows Server 2016 virtual machine named **Main-Lab3b-VM2** with the following changes:

    a. In the Azure Marketplace, in the Search bar, type **Windows Server 2016 Datacenter with Containers** and select it as the virtual machine to create.
    
    b. Place the VM in a new resource group named **Lab3b-RG**
    
    c. Set the VM size to **B4ms**
    
    d.  Ensure the **RDP (3389)** public inbound port is selected, as well as the username **Student** with a password of **Pa55w.rd1234**.

2. Once the VM is deployed, remote into it and use it for the all of the remaining exercises in this lab.


### Task 2, RDP into Main-Lab3b-VM2 and prepare VM for the lab

1.	In the Virtual Machine panel, click **Connect** to open an RDP session to the VM.
2.	Connect to Mod3bLab-vm2 as Student with a password of Pa55w.rd1234.
3.  In Sever Manager, Local Server, turn off the **IE Enhanced Security Configuration** for Administrators.
4. 	Install the Azure CLI as you previously did in Module 1, Lab C.  

>Note:  You no longer have to restart the computer for Azure CLI to load.

## Exercise 2  Create local docker image
1.	In the Start menu, right-click the **Windows PowerShell** tile and choose **Run as Administrator**
5.	Type the following commands, pressing Enter after each one.

```powershell
docker images

docker pull hello-world

docker run -it hello-world
```

6.	To see the list of containers on the server and their status, type the following press Enter:

```powershell
docker ps -a –no-trunc
```

## Exercise 3.  Create Azure Container Registry


1.	Open the browser on Main-lab5b-vm2 and connect to the Azure Portal.
2.	Click **+Create a resource**.
3.	In the Azure Marketplace, in the Search bar, type, **Container Registry**.  Then in the far-right blade, click **Create**.

![](Images\ContainerReg.PNG)

4.	In the Create a container registry blade, for the name, use **Mod3bLabcrXX** (where XX is your assigned student number).  For the Resource Group, use Mod3blab-RG, for the location, choose East US, **Enable** Admin User, and for the SKU, choose **Basic**, and then click **Create**.

5.	When deployment succeeded message is shown, click **Go to resource**.

6.	In the mod3blabcrxx blade, in the Hub menu, click **Access keys**.  Note the Registry name, Login server, Username, and Password.  Note the copy button by the password.  Click the copy button beside the top password.
 
7.	Right-click the Start menu and select **Command Prompt (Admin)**, and type the following commands, pressing Enter after each (ensure you use your student number in place of XX in each command):

```
az login 

az acr login --name mod3blabcrXX

docker login --username mod3blabcrXX --password <paste from previous copy> mod3blabcrxx.azurecr.io

docker tag hello-world mod3blabcrXX.azurecr.io/hello-world:v1

docker push mod3blabcrXX.azurecr.io/hello-world:v1

docker rmi mod3blabcrXX.azurecr.io/hello-world:v1

az acr repository list --name mod3blabcrXX --output table
```

8.	Return to the Azure portal.  The Access keys blade should still be open.  Note, in the Hub menu the **Repositories** entry below Access keys.  Click Repositories.
9.	You should see the **Hello-world** repository in the list.
10.	Return to PowerShell.  Type the following, followed by the Enter key:

```
docker run mod3blabcrXX.azurecr.io/hello-world:v1
```
11.	The hello-world container will run from the Azure Container Repository.
12.	Close all open windows, and close the RDP connection window to Mod3bLab-VM2.
13.	In Main-Lab-VM1, in the Azure portal, click Resource Groups.
14.	Delete the resource group mod3bLab-RG.
