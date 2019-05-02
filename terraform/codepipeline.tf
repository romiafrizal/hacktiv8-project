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


resource "aws_codepipeline" "hacktiv8-project-pipeline" {
  name = "hacktive8-project-pipeline"
  role_arn = "${aws_iam_role.hacktiv8-codepipeline-role.}"
}
