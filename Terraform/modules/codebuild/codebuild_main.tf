data "local_file" "codebuild_service_role" {
  filename = "${path.root}/../../../tf_aws_policies/CodeBuildServiceRole.txt"

# The file path directs to a local file outside of Terraform where the ARN numbers 
# for needed resources are stored. This is to prevent having these numbers in 
# version control.

}


resource "aws_codebuild_project" "test_build" {
  name          = var.codebuild_project_name
  description   = "test_codebuild_project"
  build_timeout = 5
  service_role  = data.local_file.codebuild_service_role.content

  artifacts {
    type     = "CODEPIPELINE"
    location = var.artifact_bucketID
  }



  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "TERRAFORM_VERSION"
      value = "1.7.3"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  source_version = "main"
}