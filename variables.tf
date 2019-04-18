variable "autoscaling_group_names" {
  description = "List of autoscaling group names to attach the lambda function to"
  type        = "list"
}

variable "tags" {
  description = "Map with additional tags to add to created resources"
  type        = "map"
  default     = {}
}

variable "lambda_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the lambda function log group"
  default     = 30
}
