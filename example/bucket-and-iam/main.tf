module "bucket" {
    source  = "github.com/muvaki/terraform-google-bucket"

    name            = "muvaki-test-bucket"
    location        = "US"

    labels = {
        application = "terraform"
    }

    iam = {
        "roles/storage.objectAdmin" = [
            "user:admin@muvaki.com",
            "serviceAccount:1111111111@cloudbuild.gserviceaccount.com"
        ],
        "project/muvaki/roles/superAdmin" = [
            "group:superadmins@muvaki.com"
        ]
    }

    # create dependency on another module (waits for output from module.project for ID)
    module_dependency   = "${module.project.id}"
}