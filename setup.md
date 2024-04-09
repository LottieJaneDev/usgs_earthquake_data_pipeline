# Project Set Up

>NOTE; Do not clone this repository until you are in the home folder of your Virtual Machine, the [installation script](C:\Users\l.pollard\usgs_earthquake_data\setup\installation.sh) will do that for your! 😄

>NOTE; the project instructions for reproducability are based on working within a Google Cloud Platform Virtual Machine environment on an [Unbuntu](https://ubuntu.com/desktop) machine. In my opinion, interacting with the GCP VM works best when using an IDE such as VS Code, where you have instant access to your files, the terminal & port forwarding, although you can use a standard terminal that allows SSH connection. If you are using anything other than the aforementioned, you may have to alter the instructions to suit your set up.  

## Project Pre-requisites

To run this project in the Cloud you will need... NOTHING! 😃 all Cloud resources are a) set up in this project b) completely free!!!

However...

To run this project locally, you will need to adjust the set up instructions and have the following installed & set up locally, I have not provided instructions for  local set up, you will need to adjust them yourself depending on your operating system:

* Google Cloud Platform Account
* Google Looker Studio Account
* Python v 3.8 >
* Google Cloud CLI SDK
* Docker
* Mage-AI v 9.0 > (includes DataBuildTools integration)
* Terraform



## Cloud Set Up


1. Follow [these instructions](/home/lottie/usgs_earthquake_data/setup/virtual_machine_setup.md) to create your:

    * *Google Cloud Platform Account*
    * *Google Cloud Platform Virtul Machine*
    * *Connect to your Virtual Machine from your local machine (Via SSH Connection)*

2. You should now be in your IDE or Terminal with an SSH connection to your virtual machine (instruction to do this in [VS Code here](https://code.visualstudio.com/docs/remote/ssh)) You will need the [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension installed if it's not already

3. If not already, `'Open a File or Folder'` in the Command Pallete `(F1)` and select the `home` folder of the virtual machine. This will display the entire contents of your virtual machine and we're ready to go!

4. Open the terminal in VS Code `(CTRL+')` and run:

    ```bash
    git clone www.REPOSITORY NAME WHEN IT'S CREATED
    ```
    Change directory into the cloned repository: 

    ```bash
    cd usgs_earthquake_data/
    ```

5. Ensure all .sh (Shell) files in the directory executable by running: 

    ```bash
    find . -type f -name "*.sh" -exec chmod +x {} \;
    ```

6. Navigate to the [install.sh](setup\install.sh) & run it to install the following software onto your virtual machine: 

    ```bash
    cd setup/ && ./install.sh
    ```

    * *Copy your Service Account Keys to the Virtual Machine*
    * *Install Anaconda on the Virtual Machine*
    * *Install Docker on the Virtual Machine*
    * *Install Terraform on the Virtual Machine*

> Note; I wasn't able to `sftp` (secure file transfer protocol) from inside the VM to 'get' the service account keys into the VM - I think maybe due to my company security restrictions. I also wasn't able to use `gcloud` library with `gcloud scp` (secure copy protocol) again, due to security restictions. I eventually had to opt for prompting the user to 'drag and drop' their Service Account Keys into the `.gcp` folder on the VM. The code & environment variables for the other options are still available but commented out. Depending on your environment & restrictions you are free to choose the most suitable option for your case. 

>> You will need to either comment out / uncomment the code in the install.sh or you can ignore, the commands should fail gracefully.  Option 'LAST RESORT' (line 12-15) is currently in play (prompting you to drag and drop your files to VS Code), if you are able to do `sftp` you should use Option A (line 94 - 106) & if you want to use `gcloud scp` you should use Option B (line 108 - 110) - I hope this makes sense - Slack me if you have any issues 😄

7. Don't forget to check docker has completed installation after the install script by closing the remote connection completely & starting it back up again. This is to refresh the User Group Policies and enforce the new policy where you are an authorised user. 

    ```bash
    docker run hello-world
    ```

    <details>
    <summary>example screenshot</summary>
    <br>
    <img src="images/docker-hello-world.jpg" alt="docker-hello-world" height="300" width="300">
    </details>
    <br>

## Project Start 

1. Spin up the project resources using Terraform (Infrastructure as Code) (Iac) follow the set [Terraform start guide here](src/terraform/README.md)




