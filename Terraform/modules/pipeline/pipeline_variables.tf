variable "artifact_bucketID" {}

variable "codebuild_project_name" {}

variable "dev_website_bucketID" {}

variable "prod_website_bucketID" {}

variable "web_url_prod" {}

variable "github_repo" {
    default = "DuncanB112P/CICD-Pipeline_Duncan0224"
}

variable "pipeline_name" {
    default = "pipeline-hcnorth-0224"
}