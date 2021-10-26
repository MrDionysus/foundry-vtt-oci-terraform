# Oracle Cloud Infrastructure (OCI) setup for Foundry VTT
This terraform code is meant to automatically build out the infrastructure you need to run a Foundry VTT instance in OCI. It was created to duplicate the instructions for creating an Always Free OCI Foundry VTT installation found at https://foundryvtt.wiki/en/setup/hosting/always-free-oracle. At this point the code DOES NOT install or configure any software on the Ubuntu VM that it creates; you'll need to follow the instructions linked above for guidance on that. 
While I've attempted to configure this so that it conforms to the "Always Free Tier" requirements of OCI, *you are fully responsible for ensuring that no costs will be incurred*.  It is recommended to conduct a Cost Analysis after this code is deployed to ensure that all services are Always Free.  An OCI Budget and Alarm are set up as part of this code to facilitate this.  

# Prerequisites
 - A valid license for [Foundry VTT](https://foundryvtt.com).
 - A new [Oracle OCI account](https://cloud.oracle.com).
 - A local installation of Terraform 1.0.8+.  Installation instructions may be found at https://learn.hashicorp.com/tutorials/terraform/install-cli+
 - General understanding of Terraform, Cloud Infrastructure, Networking, and your Operating System.  I did all of this from a Linux workstation, it should work just fine in a Windows environment as well.

# Usage
1. Clone this repo to your system
2. Create an SSH key to use to access your instance.  This key pair will be used later to allow you to SSH into your new server so that you can set up the Foundry VTT software.  Store it wherever you store your SSH keys:
  - ssh-keygen -t rsa -N "" -b 2048 -C <your-ssh-key-name> -f <your-ssh-key-name>
3. Set up your system and Terraform for OCI - https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm
  - Under "1. Prepare", follow "Create RSA Keys". Once you add them to Oracle, save the information under [DEFAULT], as you'll use that in a moment. NOTE: This is a separate key from the one you created in step 2.  You'll need them both.
4. Edit the "my-oci-conf.tfvars" file, supplying the values from the [DEFAULT] entry you copied in the previous step.  Additionally, you'll find configuration settings for the OCI Shape, boot volume, memory, OCPUs, Ubuntu image ID, and ssh_public_key path (this is the path for the key you created in step 2).  The settings in the example file will create a VM with an 80G disk, 2 OCPUs, and 12G Memory.  This uses up half of the available processor and memory resources of the Always Free Tier; adjust them according to your needs if you're trying to fit more stuff into this account.
5. Run "terraform init", followed by "terraform apply -var-file=my-oci-conf.tfvars".  You'll have to answer "yes" for the proposed changes to go through.

# What will probably happen
In my experience, it's hard to get OCI Free Tier resources - you'll probably get an error that says "Out of Capacity" when Terraform tries to create your compute instance.  The good news is that it should create the rest of the infrastructure, so you just need the compute resource.  If you're using bash, you can run the included "keeptrying.sh" script, which will try to create the compute resource every 60 seconds and will continue until it finds the word "Apply" in the results, which will happen once your instance gets created.  Mine ran for ~2 hours and was able to secure me an instance, your mileage may vary.

# Terraform .tf files overview
availability-domains.tf:
  - creates a simple data resource for your availability domains that will be used by the other Terraform files
budget-monitor.tf:
  - creates a budget with a $1 threshold and an alert that will email the address included in my-oci-conf.tfvars
compute.tf:
  - creates the compute resource
network.tf:
  - creates a networking infrastructure that will create a subnet (192.168.0.0/24) to hold your compute resource, an Internet Gateway, and some ingress rules that allow anyone (0.0.0.0) to communicate with your server over ports 22 (ssh), 80 (HTTP), 443 (HTTPS), and 30000 (Foundry)
outputs.tf:
  - creates some data outputs
provider.tf:
  - uses the variables in my-oci-conf.tfvars to configure the OCI provider
variables.tf:
  - establishes all the user variables for the other files
  
# Contact
If you have questions you can reach out to me at Grimmortis#9673 on Discord.  
 