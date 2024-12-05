# Config Manage

# Description
This project uses **Ansible** to manage the infraestructure configuration of the Production and Development servers for the **MLService** and **ConverterService**


## Tablet of Contents

- [Project Structure](#-project-structure)
- [Run the project](#run-the-project)


# 📂 Project Structure

```

├─ .github/workflows # Folder that contains the CI pipelines run  by Github Actions
│  ├─ configs-ci.yml
│  └─ main.yml

├─ group_var # Defines the variables used throught the project
│  └─ vars.yml

├─ host_vars # Ansible hosts
│  ├─ inventory.ini
│  └─ inventory.yml

├─ tasks # Ansible tasks
│  ├─ deploy_docker.yml
│  └─ deploy_nexus.yml

├─ .ansible-lint-ignore
├─ .gitignore
└─ playbook.yml # File used by ansible to run all the tasks
```




# Run the project

For the installation follow the steps described in [project configuration](https://github.com/BC-LT-AT-FS-04/ConfigManage/wiki/Local-configuration) to set the enviroment needed to run the project.  

Once you have configured your **Control node** (Ubuntu desktop) and **Managed node**(Ubuntu server Vm) you can run ansible with the following command.


* From your Ubuntu desktop machine make sure to be located in the directory with the playbook.yml file and run:

`$ ansible-playbook -i host_vars/inventory.yml playbook.yml`

**Note:** -i Refers to inventory file

 If you get an error requesting the server password add the -K flag and provide the ubuntu server password

`$ ansible-playbook -i host_vars/inventory.yml -K playbook.yml`








