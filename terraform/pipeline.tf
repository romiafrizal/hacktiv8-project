resource "aws_s3_bucket" "hacktiv8-codepipeline-bucket" {
  bucket = "hacktiv8-codepipeline-bucket"
  acl    = "private"
}

resource "aws_iam_role" "hacktiv8-codepipeline-role" {
  name = "hacktiv8-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "hacktiv8-codepipeline-policy" {
  name = "hacktiv8-codepipeline-policy"
  role = "${aws_iam_role.hacktiv8-codepipeline-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "${aws_s3_bucket.hacktiv8-codepipeline-bucket.arn}",
        "${aws_s3_bucket.hacktiv8-codepipeline-bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_codepipeline" "hacktiv8-codepipeline" {
  name     = "hacktiv8-codepipeline"
  role_arn = "${aws_iam_role.hacktiv8-codepipeline-role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.hacktiv8-codepipeline-bucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OAuthToken  = "${var.GITHUB_TOKEN}"
        Owner       = "romiafrizal"
        Repo        = "hacktiv8-wp-test"
        Branch      = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ProjectName = "hacktiv8-project"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CloudFormation"
      input_artifacts  = ["build_output"]
      version          = "1"

      configuration {
        ActionMode     = "REPLACE_ON_FAILURE"
        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName      = "Hacktiv8-Stack"
        TemplatePath   = "build_output::sam-templated.yaml"
      }
    }
  }
}
