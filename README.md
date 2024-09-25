# Reviews Website Repository

## Overview

This repository is designed for creating a reviews website. The architecture is based on AWS services like EC2 and S3, and it uses Bitbucket Pipelines for CI/CD. This README provides an overview of each directory and file, as well as the commands for deployment.

## Table of Contents

1. [Overview](#overview)
2. [Table of Contents](#table-of-contents)
3. [Directory Structure](#directory-structure)
4. [Description of Key Directories and Files](#description-of-key-directories-and-files)
5. [Deployment](#deployment)
6. [Additional Notes](#additional-notes)

## Directory Structure

```
.
├── ansible
├── bitbucket-pipelines.yml
├── ec2-website-bitbucket-pipelines.yml
├── server_config
├── site_code
├── static_s3_website
├── terraform
└── text_content
```

## Description of Key Directories and Files

### Ansible

This directory contains Ansible playbooks for various server configurations:

- `configure_server_permissions.yml`: Configure server permissions.
- `copy_files.yml`: Copy files to the server.
- `cron_jobs.yml`: Create cron jobs for server maintenance.
- `emacs.yml`: Install the Emacs editor.
- `fail2ban.yml`: Enhance server security using Fail2Ban.
- `hosts.yml`: Ansible hosts file.
- `install_git_zsh.yml`: Install git, zsh, curl, and wget.
- `server_initial_setup.yml`: Initial setup, installs curl, openlitespeed, PHP, etc.
- `ssh.yml`: Secure SSH configuration.
- `ufw.yml`: Configure UFW for security.

### Site Code

Contains the actual HTML and CSS code for the website.

### Terraform

Two sets of Terraform scripts are included:

- One for deploying the website on an AWS EC2 instance.
- Another for setting up the website as a static site hosted on an S3 bucket with CloudFront.

### Text Content

Contains textual content displayed on the website.

### Bitbucket Pipelines

Two pipeline files are available:

- `bitbucket-pipelines.yml`: For deploying the static site on S3.
- `ec2-website-bitbucket-pipelines.yml`: For deploying the site on EC2.

## Deployment

### Static Site on S3

Use the following command in your Bitbucket Pipeline:

```
aws s3 sync site_code/final_code/ s3://trendingtechdevices.com
```

### EC2 Deployment

Use the following Ansible commands in your Bitbucket Pipeline:

```
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/hosts.yml ansible/copy_files.yml -v
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/hosts.yml ansible/configure_server_permissions.yml -v
```

## Additional Notes

- The website is developed using HTML and CSS.
- For further security measures, the repository includes configurations for SSH and UFW.
