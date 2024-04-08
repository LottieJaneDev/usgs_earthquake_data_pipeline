# Google Cloud Platform | Virtual Machine Set Up

> !Note: _Commands are displayed as `bash` by default, you may need to adjust them to your local shell if you are working outside of the Virtual Machine._
> !Note: It is possible to set up your virtual machine using Terraform if you have it installed locally already. See Terraform directory [here](src\terraform). You can then skip to "_Connecting to the Virtual Machine from your Local Machine_" below.

## Account & Project

If you are unfamiliar with this way of working, I highly recommend following this guidance on ['Setting up the Environment on Google Cloud VM & SSH Access'](https://youtu.be/ae-CV2KfoN0?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

----------------------

1. Go to [Google Cloud Platform](https://cloud.google.com) & create a FREE Google Cloud Platform account. You will recieve $300 of credits to use over a 90 day trial period. This will be more than enough to both replicate this project & trial GCP for yourself. Check out > [DataTalksClub](https://www.youtube.com/c/DataTalksClub) < for tutorials and much more!

    > NOTE:  You will need to provide a payment method to set up your GCP account, but nothing will be taken until after your 90 day free trial or your $300 free credits expire.

2. Create a new project named `'usgs-earthquake-data'`

3. Enable the `Service Usage API` manually to allow for smooth interaction between Terraform & GCP during resource provisioning later on. Click here to enable the API for your project => ['ENABLE SERVICE USAGE API'](https://console.cloud.google.com/apis/library/serviceusage.googleapis.com/)

4. Create a GCP Virtual Machine to leverage external cloud computing power & better compatability, reducing local hardward/software restrictions

    From the main menu of your project, navigate to `Compute Engine - VM Instances` you be prompted to enable the `Compute Engine API`, enable this, click `CREATE INSTANCE` & set up your Virtual Machine

    > NOTE:
    >Set up all resources throughout this project in the US Region to avoid inter-region incompatibility. Create the VM in any US Region & Zone
    > e2-standard-4 | ubuntu-22.04 LTS amd64 focal image built on v20240307 x86/64 Architecture | Balanced persistent disk | 60GB
    >Allow 'full access to all Cloud APIs' | Advanced Networking: Static External IP Address is highly recommended in Network Settings

    <details>
    <summary>example screenshot</summary>
    <img src="images/machine-config1.jpg" alt="VM-CONFIG" height="300" width="600">
    <img src="images/machine-config2.jpg" alt="VM-CONFIG" height="300" width="600">
    </details>
    <br>

    >>The 'Monthly estimate' you are given is if you were to leave the VM running 24/7, which we will not. I've used mine pretty much every day, I am on the last day of my trial today & still have £57 remaining. Just make sure you set a reminder for the last day of your free trial and be sure to shut everything down & cancel your account before it ends

----------------------

## Connecting to the Virtual Machine from your Local Machine

To connect to the VM from your local machine, you will need to create an [SSH Key](https://cloud.google.com/compute/docs/instances/ssh), instructions also in the above [linked video](https://youtu.be/ae-CV2KfoN0?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb) and [GCP docs here](https://cloud.google.com/compute/docs/connect/create-ssh-keys#linux-and-macos).


<details>
  <summary>Instructions if required | Setting up SSH Keys</summary>
  
Choose your preferred local directory to save your SSH keys securely in a hidden `.ssh` folder. The filename could be `gcp_vm_ssh` for example, `username` would be your preferred name

Open a local `Git Bash` terminal where `ssh-keygen` is pre-installed:

If you don't already have a folder for `SSH Keys` create one:

```bash
mkdir .ssh
```

```bash
ssh-keygen -t rsa -f ~/.ssh/KEY_FILENAME -C USERNAME -b 2048
```

`ssh-keygen` will save your private key file `~/.ssh/KEY_FILENAME` and your public key file `~/.ssh/KEY_FILENAME.pub`

Disply the contents of the file & copy it:

```bash
cat ~/.ssh/KEY_FILENAME.pub | clip
```

* Navigate back to Google Cloud Platform Console
* Back to the `Compute Engine` on the left menu
* Scroll down to `metadata` & click `SSH Keys` 
* Click `Add SSH Key` & paste the key into the box 
* Save the SSH Key 
* Go to the `Compute Engine` page & copy the `External IP Address`

Now go back to your Git Bash terminal & run: 

```bash
ssh -i ~/.ssh/KEY_FILENAME USERNAME@EXTERNAL_IP
```

Confirm with a `yes` | Note; if you put a password in here, then you'll have to do this every time you log in so unless you require one for security, you can leave it blank by pressing `enter`

You should now see the homescreen of your Virtual Machine 

<img src="images\bash-ssh-screen.jpg" alt="bash-ssh-login" height="300" width="600">

`Ctrl + D` to log out of the VM. We will now set up a `config` file to allow for easier access each time using just `ssh vm-name` 

```bash
touch ~/.ssh/config && nano ~/.ssh/config
```

```bash 
Host VM_NAME
    HostName VM_EXTERNAL_IP_ADDRESS
    User USERNAME_FROM_BEFORE 
    IdentityFile absolute/path/to/.ssh/key
```

`Ctrl + O` `Enter` `Ctrl + X` to write, save & exit 

Now, open a new terminal & type in `ssh VM-NAME` and you'll have instant access to your virtual machine! 😄

</details>


>In my opinion, interacting with the GCP VM works best when using an IDE such as VS Code, where you have instant access to your files, the terminal & port forwarding, although you can use a standard terminal that allows SSH connection.
>NOTE; You will need the [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension installed in VS Code if it's not already.

Once you have created the SSH key connection as above, you simply need to open your local terminal and run `ssh name-of-virtual-machine`, so in my case I'd type `ssh usgs-vm` it would connect to the virtual machine & I'd be interacting as that machine from then on. Should you need to exit the connection, press `CTRL + Z` to escape out, then `ssh usgs-vm` to get back in, it really is that simple!

> NOTE; if you get a `connection error 22` - make sure your virtual machine has been started & is up and running with a green tick in Google Cloud Console
> NOTE; if you are not using a Google Cloud Virtual Machine for the recreation of this project, you will also need to install `Google Cloud CLI` on your local machine. Follow Google Cloud's [instructions here](https://cloud.google.com/sdk/docs/install-sdk), choose your operating system (OS) and follow along with the guide. Alternatively, if you have Docker installed locally, and are familiar with it's usage, you are able to use `Google Cloud CLI` via a docker image & subsequent container [here.](https://cloud.google.com/sdk/docs/downloads-docker)

>>> **IMPORTANT!!!** Remember to START and STOP the virtual machine only when in use as you will incur charges (from your free credits) per hour that it's running, you will see that these charges are minimal for keeping the virtual machine running but increase on days where you use more compute resources for tasks like data ingestion, transformations etc. Google has a handy tooltip that appear at the top of each log in telling you how many free credits you have & how many days left of your free trial.

----------------------

## Identity Access Managment (IAM) & Admin

It is considered best practice to maintain separate [service accounts](https://cloud.google.com/iam/docs/service-account-overview/) for each distinct service such as Docker, Terraform, DBT, and Mage. This approach enhances security and simplifies access control measures within a system. By assigning unique service accounts to each service, organisations can implement granular permissions, limiting the scope of access each service has to resources and data. In the event of a security breach or unauthorised access, the impact can be contained to the specific service affected, reducing the overall risk to the system.Separate service accounts also facilitate auditing and monitoring efforts, enabling administrators to track and analyse the activities of individual services more effectively. This segregation of duties contributes to a more robust and secure infrastructure overall.

We will create the individual services accounts for each tool used in this project & assign their required roles accordingly.

**Create Service Accounts:**

* Go to the `"IAM & Admin"` section in the Google Cloud Console
* Select `"Service Accounts"` from the left-hand menu
* Click on `"Create Service Account"`
* Provide a name and description for the service account
* Click on `"Create"`

<details>
<summary>example screenshot</summary>
<img src="images/service-account-setup1.jpg" alt="serviceaccountsetup" height="300" width="600">
</details>


**Assign Roles:**

* Next we will grant permissions for each service account accordingly depending on the resources they will need access to. This is to maintain security & modularity
* In the "Select a role" dropdown, choose the appropriate roles for each service:

  * __Mage__ | _BigQuery Admin, Storage Admin_ - so far... #maybe service account token creator
  * __Terraform__ | _Storage Admin, Storage Object Admin, BigQuery Admin_ 
  #maybe service account token creator, maybe editor, service usage admin, Owner

#############################################

If I use MAGE with Cloud Run = 
- Artifact Registry Read (mage)
- Artifact Registry Writer (mage)
- Cloud Run Developer (mage in the cloud) (try Cloud Run Admin instead) 
- Cloud SQL Admin (mage in the cloud)
- Service Account Token Creator (mage in the cloud)
- BigQuery Admin (BigQuery) # if needed 
- Cloud Vision AI Service Agent (Vision) # if needed
- Service Usage Admin () # if needed
- Service Object Viewer () # if needed
NB - if i do use this path then add into the further ideas - using GCP bigquery secrects manager

#####################################################
  
>Note; for this project we will use the [DataBuildTools (DBT)] integration that is conveniently built into Mage so we won't need a separate service account for DBT.

<details>
<summary>example screenshot</summary>
<img src="images/service-account-setup2.jpg" alt="serviceaccountsetup" height="300" width="600">
</details>


**Generate Keys & Download Credentials:**

* After assigning roles, navigate to the `"Manage keys"` by clicking on the ... under 'Actions'
* Click on `"Add Key"` and select `"Create new key"`
* Choose the key type as JSON
* Click on `"Create"` this will download a .JSON file containing the service account's credentials to your **LOCAL MACHINE'S downloads directory**
* Navigate to this folder & rename the key as it will download with a randomised name

> ! Rename them as one at a time after download as you will get confused which is which. I recommend simply adding "mage" or "terraform" as a prefix for example; `"terraform-usgs-earthquake-data-18ebd2b625cf.json"` & `"mage-usgs-earthquake-data-26edd8b928cl.json"`

* We will use these keys once we are working inside our virtual machine

<details>
<summary>example screenshot</summary>
<img src="images/service-account-keys.jpg" alt="serviceaccountkeys" height="300" width="600">
</details>

------------------------

Now you have a Google Cloud Platform Account, a working Ubuntu Linux Virtual Machine PLUS Docker & Terraform installed! A pretty good set up for creating projects 😃

Head back here to the [main setup](setup.md) for the next step! 💻

------------------------
