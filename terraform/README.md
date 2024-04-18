# Terraform | Google Cloud Platform Resources

![Terraform](https://img.shields.io/badge/Terraform-1.7-black?style=flat&logo=terraform&logoColor=white&labelColor=573EDA)
![GCP](https://img.shields.io/badge/Google_Cloud-3772FF?style=flat&logo=googlecloud&logoColor=white&labelColor=3772FF)

Whilst it is indeed possible to provision a Google Cloud Platform (GCP) virtual machine (VM) using Terraform (IaC), I have opted not to utilise this approach. There are two main reasons for this decision. Firstly, it would necessitate its installation locally & outside of the virtual environment we've established using. Secondly, even if Terraform were locally installed, the provisioning process of a virtual machine takes longer in comparison to manually creating the VM instance in the GCP Console. However, should you wish to explore Infrastructure as Code (IaC) in the future, here is a [link to the Terraform Registry Template for a GCP VM](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template), I have provided a [virtual machine provisioning script](../scripts/virtual_machine.tf). Embracing IaC and version controlling infrastructure provides multiple benefits such as enhanced consistency, reproducibility, and scalability across dev teams working on a large project. These services are important to maintain cohesion and efficiency across collaborative development projects.


## _Initialise Terraform_

In Terraform, you'll encounter several essential commands: "terraform init" initializes a working directory, "terraform validate" checks configuration syntax, "terraform apply" applies changes to provision/update resources, and "terraform destroy" removes all defined resources. These commands constitute the fundamental workflow of Terraform usage. For further details on Terraform's functionalities and workflows, refer to the official Terraform documentation.

Initialise Terraform by running the below code block: 

```bash
cd ~/usgs_earthquake_data_pipeline/terraform/ && ./terraform.sh
```

NOTE - `terraform.tfvars` is best practice but for automation & reproducibility purposes in this project we are passing the .env file across each tools environment. 

To delete these resources, you will need to open [terraform.sh](../setup/terraform.sh) & uncomment the final `Terraform destroy` block OR.. run the [shutdown.sh](../setup/shutdown.sh) script when you have finished with the project for an automated way to destroy resources, kill Docker containers & log out of the virtual machine. 

⚠️ Running `terraform destroy` will NOT destroy the Virtual Machine you manually created. Please see below & the setup.md for further information on how to dompletely close your GCP account and resources. 

```bash
 terraform destroy -auto-approve \
   -var="project=${GCP_PROJECT_NAME}" \
   -var="location=${GCP_LOCATION}" \
   -var="region=${GCP_REGION}" \
   -var="zone=${GCP_ZONE}" \
   -var="gcs_bucket_name=${GCP_GC_STORAGE_BUCKET_NAME}" \
   -var="bq_dataset_name=${GCP_BIGQUERY_DATASET_NAME}" \
```

⚠️ IMPORTANT ⚠️ Make sure that your Terraform resources (BigQuery Datasets & Tables & Google Cloud Storage Buckets) have been destroyed by manually checking as well, just to be sure the destruction completed & to 100% avoid being charged for any provisioned resources. 

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

Head back to the [setup](../setup.md) file for the next step! 😃