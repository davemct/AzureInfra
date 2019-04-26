# Global Azure Bootcamp 2019: Integrating with Azure Compute Services

### Lab: Creating Containers in Azure

In this lab, you will learn how to migrate apps that run on-premises in Docker containers to Azure so that they run in Docker containers in the cloud.

## Exercise 1, Create and prepare VM for Lab

### Task 1, Create the Windows Server 2016 Datacenter with Containers virtual machine

1.  Create a new Windows Server 2016 virtual machine named **GABC-VM3** with the following changes:

    a. In the Azure Marketplace, in the Search bar, type **Windows Server 2016 Datacenter with Containers** and select it as the virtual machine to create.
       
    b. Place the VM in a new resource group named **GABC-RG2**
    
    c. Set the VM size to **B4ms**
    
    d.  Ensure the **RDP (3389)** public inbound port is selected, as well as the username **Student** with a password of **Pa55w.rd1234**.

2. Once the VM is deployed, remote into it and use it for the all of the remaining exercises in this lab.


### Task 2, RDP into GABC-VM3 and prepare VM for the lab

1.	In the Virtual Machine panel, click **Connect** to open an RDP session to the VM.
2.	Connect to GABC-VM3 as Student with a password of Pa55w.rd1234.
3.  In Sever Manager, Local Server, turn off the **IE Enhanced Security Configuration** for Administrators.
4. 	Install the Azure CLI as follows:  

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


1.	Open the browser on GABC-VM3 and connect to the Azure Portal.
2.	Click **+Create a resource**.
3.	In the Azure Marketplace, in the Search bar, type, **Container Registry**.  Then in the far-right blade, click **Create**.

![](Labfiles\Images\ContainerReg.PNG)

4.	In the Create a container registry blade, for the name, use **GABCContLabcrXX** (where XX is your assigned student number).  For the Resource Group, use GABC-RG2, for the location, choose East US, **Enable** Admin User, and for the SKU, choose **Basic**, and then click **Create**.

5.	When deployment succeeded message is shown, click **Go to resource**.

6.	In the GABCContlabcrxx blade, in the Hub menu, click **Access keys**.  Note the Registry name, Login server, Username, and Password.  Note the copy button by the password.  Click the copy button beside the top password.
 
7.	Right-click the Start menu and select **Command Prompt (Admin)**, and type the following commands, pressing Enter after each (ensure you use your student number in place of XX in each command):

```
az login 

az acr login --name GABCContlabcrXX

docker login --username GABCContlabcrXX --password <paste from previous copy> mod3blabcrxx.azurecr.io

docker tag hello-world GABCContlabcrXX.azurecr.io/hello-world:v1

docker push GABCContlabcrXX.azurecr.io/hello-world:v1

docker rmi GABCContlabcrXX.azurecr.io/hello-world:v1

az acr repository list --name GABCContlabcrXX --output table
```

8.	Return to the Azure portal.  The Access keys blade should still be open.  Note, in the Hub menu the **Repositories** entry below Access keys.  Click Repositories.
9.	You should see the **Hello-world** repository in the list.
10.	Return to PowerShell.  Type the following, followed by the Enter key:

```
docker run GABCContlabcrXX.azurecr.io/hello-world:v1
```
11.	The hello-world container will run from the Azure Container Repository.
12.	Close the RDP connection to GABC-VM3.
13. In the Azure portal, click Resource Groups.
14.	Delete the resource group GABC-RG2.
