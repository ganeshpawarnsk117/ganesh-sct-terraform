# modules/sns/main.tf

variable "topic_name" {
  description = "The name of the SNS topic"
}

variable "subscription_endpoint" {
  description = "The endpoint to subscribe to the SNS topic (optional)"
}

variable "subscription_protocol" {
  description = "The protocol for the subscription (optional)"
  default     = "email"
}

variable "topic_type" {
  description = "The type of the SNS topic. Valid values: Standard or FIFO"
  default     = "Standard"
}

variable "enable_encryption" {
  description = "Enable encryption for the SNS topic"
  default     = false
}

resource "aws_sns_topic" "this" {
  name = var.topic_name
  fifo_topic = var.topic_type == "FIFO" ? true : false

  dynamic "encryption" {
    for_each = var.enable_encryption == true ? [1] : []
    content {
      encryption_enabled = true
    }
  }
}

resource "aws_sns_subscription" "this" {
  count           = var.subscription_endpoint != null ? 1 : 0
  topic_arn       = aws_sns_topic.this.arn
  endpoint        = var.subscription_endpoint
  protocol        = var.subscription_protocol
}


# main.tf

module "sns_topic" {
  source                = "./modules/sns"
  topic_name            = "example-topic"
  subscription_endpoint = "example@example.com"
  subscription_protocol = "email"
  topic_type            = "FIFO"
  enable_encryption     = true
}
