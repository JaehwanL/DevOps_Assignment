resource "aws_ecr_repository" "jaehwan-helloworld" {
  name                 = "jaehwan-helloworld"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "jaehwan-helloworld" {
  repository = aws_ecr_repository.jaehwan-helloworld.name

  policy = data.aws_iam_policy_document.test.json
}

data "aws_iam_policy_document" "test" {
  statement {
    sid    = "test common policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["164828680675"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}