# resource "aws_s3_bucket" "obinna" {
#   bucket = "obinna-s3bucket"


#     tags = {
#         Name        = "obi-bucket1"
#         Environment = "Dev"
#       }
#     }

# resource "aws_s3_bucket_public_access_block" "obinna" {
#   bucket = aws_s3_bucket.obinna.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket" "terraform_state" {
#   bucket        = "my-terraform-state-lock"
#   force_destroy = true
# }

# resource "aws_s3_bucket_ownership_controls" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"  #ObjectWriter or BucketOwnerEnforced(this breaks)
#   }
# }

# resource "aws_s3_bucket_acl" "terraform_state" {
#   depends_on = [aws_s3_bucket_ownership_controls.terraform_state]

#   bucket = aws_s3_bucket.terraform_state.id
#   acl    = "private"
# }

# Private Bucket With Tags
resource "aws_s3_bucket" "example" {
  bucket = "obi-tf-test-bucket"

  tags = {
    Name        = "obi-bucket"
    Environment = "Dev"
  }
}
