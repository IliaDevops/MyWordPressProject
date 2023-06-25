resource "aws_iam_user" "user" {
  name = var.iam-user
}


resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

variable "iam-user" {
  type = string

}
