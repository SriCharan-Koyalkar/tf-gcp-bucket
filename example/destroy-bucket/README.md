# Teardown bucket

Buckets are not easily removable resource, especially if they have objects inside them. This example shows how you can remove a bucket. Its a two step process if you require to remove a bucket that has been provisioned via terraform.

1. set force_destroy to "true"
2. terraform apply (ALL Objects within bucket will also be removed)
3. remove the module entry from terraform configs
4. terraform apply so terraform state file gets updated with the removed module.