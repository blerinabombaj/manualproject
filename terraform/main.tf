terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.33"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["c7i-flex.large"]
    }
  }

  tags = {
    Environment = "dev"
    Project     = "todo-app"
  }
}

resource "aws_security_group_rule" "nodes_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "nodes_ingress_backend" {
  type              = "ingress"
  from_port         = 5001
  to_port           = 5001
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.node_security_group_id
}

resource "aws_s3_bucket" "todo_app_backup" {
  bucket = "todo-app-backup-rl"

  tags = {
    Name        = "todo-app-backup"
    Environment = "dev"
  }
}

resource "aws_iam_policy" "s3_backup_policy" {
  name        = "todo-app-s3-backup-policy"
  description = "Allow writing backups to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.todo_app_backup.arn,
          "${aws_s3_bucket.todo_app_backup.arn}/*"
        ]
      }
    ]
  })
}

data "aws_iam_openid_connect_provider" "eks" {
  url = "https://oidc.eks.eu-west-1.amazonaws.com/id/34BC78F4E9861A5795BBB18675E9E114"
}

resource "aws_iam_role" "s3_backup_role" {
  name = "todo-app-s3-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${data.aws_iam_openid_connect_provider.eks.url}:sub" = "system:serviceaccount:todo-app:backup-service-account"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_backup_attach" {
  role       = aws_iam_role.s3_backup_role.name
  policy_arn = aws_iam_policy.s3_backup_policy.arn
}