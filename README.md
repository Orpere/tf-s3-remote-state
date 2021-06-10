# tf-s3-remote-state

- [x] Install [git](https://gist.github.com/derhuerst/1b15ff4652a867391f03)
- [x] How to use this repo

```bash
git clone git@github.com:orlando-pereira/tf-s3-remote-state.git
```

- Change into the directory :
  
```bash
cd tf-s3-remote-state
```

- [x] create a s3 backend with dynamodb table for the locks
- [x] prepare example
- [x] create 2 workspaces prod and stag
- [x] check the s3_buckets and you can see two environments

- create a s3 backend with dynamodb table for the locks
  
  ```bash
   cd S3-backend
  ```

  - create a terraform.tfvars file and update the values
  
  ```terraform
  region = "us-east-1"
  bucket_name = "<bucket_name>"
  table_name = "<table_name>"
  ```

  - run terraform init && terraform apply

  ```terraform
    terraform init

    Initializing the backend...

    Initializing provider plugins...

    The following providers do not have any version constraints in configuration,
    so the latest version was installed.

    To prevent automatic upgrades to new major versions that may contain breaking
    changes, it is recommended to add version = "..." constraints to the
    corresponding provider blocks in configuration, with the constraint strings
    suggested below.

    * provider.aws: version = "~> 2.42"

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ➜  S3-backend terraform apply

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      # aws_dynamodb_table.terraform_locks will be created
      + resource "aws_dynamodb_table" "terraform_locks" {
          + arn              = (known after apply)
          + billing_mode     = "PAY_PER_REQUEST"
          + hash_key         = "LockID"
          + id               = (known after apply)
          + name             = "orlando-locks"
          + stream_arn       = (known after apply)
          + stream_label     = (known after apply)
          + stream_view_type = (known after apply)

          + attribute {
              + name = "LockID"
              + type = "S"
            }

          + point_in_time_recovery {
              + enabled = (known after apply)
            }

          + server_side_encryption {
              + enabled = (known after apply)
            }
        }

      # aws_s3_bucket.terraform_state will be created
      + resource "aws_s3_bucket" "terraform_state" {
          + acceleration_status         = (known after apply)
          + acl                         = "private"
          + arn                         = (known after apply)
          + bucket                      = "orlando-test"
          + bucket_domain_name          = (known after apply)
          + bucket_regional_domain_name = (known after apply)
          + force_destroy               = true
          + hosted_zone_id              = (known after apply)
          + id                          = (known after apply)
          + region                      = (known after apply)
          + request_payer               = (known after apply)
          + website_domain              = (known after apply)
          + website_endpoint            = (known after apply)

          + server_side_encryption_configuration {
              + rule {
                  + apply_server_side_encryption_by_default {
                      + sse_algorithm = "AES256"
                    }
                }
            }

          + versioning {
              + enabled    = true
              + mfa_delete = false
            }
        }

    Plan: 2 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

      Enter a value: yes

    aws_dynamodb_table.terraform_locks: Creating...
    aws_s3_bucket.terraform_state: Creating...
    aws_s3_bucket.terraform_state: Creation complete after 8s [id=orlando-test]
    aws_dynamodb_table.terraform_locks: Still creating... [10s elapsed]
    aws_dynamodb_table.terraform_locks: Creation complete after 18s [id=orlando-locks]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    dynamodb_table_name = orlando-locks
    s3_bucket_arn = arn:aws:s3:::orlando-test
    ```

- prepare example
  
  ```terraform
  cd ../example
  ```
  
  - update the values on main.tf 
  
  ```terraform
    backend "s3" {

      # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
      # manually, uncomment and fill in the config below.

      bucket         = "<bucket_name>"
      key            = "<key_path>/terraform.tfstate"
      region         = "us-east-1"
      dynamodb_table = "<table_name>"
      encrypt        = true

  ```

  - run a terraform init
  
  ```terraform
     ➜  example terraform init

    Initializing the backend...

    Initializing provider plugins...

    The following providers do not have any version constraints in configuration,
    so the latest version was installed.

    To prevent automatic upgrades to new major versions that may contain breaking
    changes, it is recommended to add version = "..." constraints to the
    corresponding provider blocks in configuration, with the constraint strings
    suggested below.

    * provider.aws: version = "~> 2.42"

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
  ```

- create 2 workspaces prod and stag

```terraform
➜  example terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.

➜  example terraform workspace new stag
Created and switched to workspace "stag"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration
```

- check the s3_buckets and you can see two environments
  - now you can check the aws console your bucket has the follow structure

    Amazon S3/<bucket>/env:/<prod || stag >/<key_path>/terraform.tfstate
