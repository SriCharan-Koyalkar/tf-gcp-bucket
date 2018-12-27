module "bucket" {
    source  = "github.com/muvaki/terraform-google-bucket"

    name            = "muvaki-test-bucket"
    force_destroy   = "true"
}