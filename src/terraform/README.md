# Terraform | Google Cloud Platform Resources

![Terraform](https://img.shields.io/badge/Terraform-1.7-black?style=flat&logo=terraform&logoColor=white&labelColor=573EDA)
![GCP](https://img.shields.io/badge/Google_Cloud-3772FF?style=flat&logo=googlecloud&logoColor=white&labelColor=3772FF)

Whilst it is indeed possible to provision a Google Cloud Platform (GCP) virtual machine (VM) using Terraform (IaC), I have opted not to utilise this approach. There are two main reasons for this decision. Firstly, it would necessitate its installation locally & outside of the virtual environment we've established using. Secondly, even if Terraform were locally installed, the provisioning process of a virtual machine takes longer in comparrison to manually creating the VM instance in the GCP Console. However, should you wish to explore Infrastructure as Code (IaC) in the future, here is a [link to the Terraform Registry Templace for a GCP VM](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template), I have provided a [virtual machine provisioning script](virtual_machine.tf). Embracing IaC and version controlling infrastructure provides multiple benefits such as enhanced consistency, reproducibility, and scalability across dev teams working on a large project. These services are important to maintain cohesion and efficiency across collaborative development projects.


## _Initialise Terraform_

In Terraform, you'll encounter several essential commands: "terraform init" initializes a working directory, "terraform validate" checks configuration syntax, "terraform apply" applies changes to provision/update resources, and "terraform destroy" removes all defined resources. These commands constitute the fundamental workflow of Terraform usage. For further details on Terraform's functionalities and workflows, refer to the official Terraform documentation.

Initialise Terraform by running the below code block: 

```bash
cd ~/usgs_earthquake_data/src/terraform/ && ./terraform.sh
```

NOTE - `terraform.tfvars` is best practice but for automation & reproducibility purposes in this project we are passing the .env file across each tools environment. 

To delete these resources, you will need to open [terraform.sh](terraform.sh) & uncomment the final `Terraform destroy` block. 

```bash
 terraform destroy -auto-approve \
   -var="project=${GCP_PROJECT_NAME}" \
   -var="location=${GCP_LOCATION}" \
   -var="region=${GCP_REGION}" \
   -var="zone=${GCP_ZONE}" \
   -var="gcs_bucket_name=${GCP_GC_STORAGE_BUCKET_NAME}" \
   -var="bq_dataset_name=${GCP_BIGQUERY_DATASET_NAME}" \
```

<table>
   <tr>
      <td>⚠️</td>
      <td>
         <strong>Please note:</strong>  that executing terraform destroy will permanently delete the provisioned resources, including the Google Cloud Storage bucket and BigQuery dataset. This action is irreversible and should be undertaken with caution, ideally when you have concluded your project or no longer require these resources.
         <br><br>
         It's important to understand that Terraform follows an infrastructure-as-code approach, meaning that the state of your infrastructure is represented by the Terraform configuration files. Running terraform apply after terraform destroy will recreate these resources according to the current state defined in your configuration files. However, it's essential to remember that this will result in the creation of new, empty resources, and any existing data will be lost.
         <br><br>
         Therefore, exercise careful consideration before initiating terraform destroy, ensuring it aligns with your project objectives and requirements. Always maintain regular backups of critical data to mitigate potential data loss scenarios. If you're unsure about whether to proceed with destroying resources, consult with your team or a qualified professional to evaluate the impact on your project.
      </td>
   </tr>
</table>
<br>




##############################################################################
########## IF I HAVE TIME ADD IN CLOUD RUN ETC WITH MAGE TERRAFORM ###########

Another config for terraform: potentially using google cloud run 

2. Export the following environment variables 

Change the values of the following environment variables or set them in the `variables.tf` file

```bash
export GOOGLE_PROJECT=[project-name]
export GOOGLE_PROJECT_ID=[project-id]
export GCP_REGION=[region]
export GCP_ZONE=[us-central1-c]
export GCP_LOCATION=[location]
export DB_PASSWORD=[database_password]
```

Note: The DB_PASSWORD parameter is for the Postgres database that will be used by Mage.ai's internal operations. The dashboard's data will be stored in a BigQuery dataset. 

1. Provision cloud resources with terraform

*terraform init* 
```bash
cd terraform \
terraform init
```

*terraform plan*
```bash
terraform plan \
  -var="project=${GOOGLE_PROJECT}" \
  -var="project_id=${GOOGLE_PROJECT_ID}" \
  -var="region=${GCP_REGION}" \
  -var="zone=${GCP_ZONE}" \
  -var="location=${GCP_LOCATION}"
```

*terraform apply*
```bash
terraform apply \
  -var="project=${GOOGLE_PROJECT}" \
  -var="project_id=${GOOGLE_PROJECT_ID}" \
  -var="region=${GCP_REGION}" \
  -var="zone=${GCP_ZONE}" \
  -var="location=${GCP_LOCATION}"
```

Terraform will deploy Mage.ai as a Google Clound Run service, which you can access by navigating to the Cloud Run option on the left navigation menu. On the service details page, you'll find the URL of the running service listed under the "Service URL" section. Copy & go to this URL to find the Mage.ai service:

[]

Once inside Mage.ai service, you'll find the money_diaries pipeline already created. To run the pipeline, click on it to go the triggers page then press the Run@Once button, then the Run Now button in the Run Pipeline Now pop-up window. You can view the run's log by going to Run on the left navigation menu and clicking on the logs logo next to the Running pipeline:

[]

The pipeline will extract the blog posts from Money Diaries and load them into the BigQuery dataset called money_diaries, also provisioned by Terraform. You can view the dataset by navigating to BigQuery on the left navigation menu, then click on BigQuery Studio. Once the Explorer loads, expand the project containing your dataset to list all datasets: 

[]

To delete these resources, run the `terraform destroy` command:

*terraform destroy*
```bash
terraform destroy \
  -var="project=${GOOGLE_PROJECT}" \
  -var="project_id=${GOOGLE_PROJECT_ID}" \
  -var="region=${GCP_REGION}" \
  -var="zone=${GCP_ZONE}" \
  -var="location=${GCP_LOCATION}"
```




-------------------------

Bruno's terraform: 


Now, export the environment variables `GOOGLE_APPLICATION_CREDENTIALS` pointing to the full path where the .json credentials file was downloaded/saved:

```shell
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/gcp-credentials.json
```

Initialise Terraform Modules

```shell
terraform init
```

Edit the variables in [terraform.tfvars](terraform.tfvars):  

Edit the values of the variables (`project_id`, `lakehouse_raw_bucket`, `bigquery_raw_nyc_tlc`) to your suit your project

Create the resources with Terraform 

```bash
terraform plan
```

```bash
terraform apply --auto-approve
```