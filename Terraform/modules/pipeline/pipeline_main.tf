/*The data file paths direct to local files outside of Terraform where the ARN numbers 
 for needed resources are stored. This is to prevent having these numbers in 
 version control. */

data "local_file" "codepipeline_service_role" {
  filename = "${path.root}/../../../tf_aws_policies/CodePipelineServiceRole.txt"
}

data "local_file" "codestar_connection_credentials" {
  filename = "${path.root}/../../../tf_aws_policies/codestar_connection_credentials.txt"
}


resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = data.local_file.codepipeline_service_role.content

  artifact_store {
    location = var.artifact_bucketID
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = data.local_file.codestar_connection_credentials.content
        FullRepositoryId = var.github_repo
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
    name = "Deploy_to_dev_bucket"
    action {
      name            = "Deploy_to_bucket"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = var.dev_website_bucketID
        Extract    = "true"
      }
    }
  }

  stage {
    name = "Approve"
    action {
      name            = "Approval"
      category        = "Approval"
      owner           = "AWS"
      provider        = "Manual"
      version         = "1"
    }
  }

  stage {
    name = "Deploy_to_prod_bucket"
    action {
      name            = "Deploy_to_prod_bucket"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = var.prod_website_bucketID
        Extract    = "true"
      }
    }
  }
}