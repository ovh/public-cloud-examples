########################################################################################
#     Bucket
########################################################################################
resource "aws_s3_bucket" "ai-s3" {
  count = var.number_of_attendees
  bucket = "${var.team}-${count.index}"
}