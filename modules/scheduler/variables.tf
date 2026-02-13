variable "name" {
  description = "Name of the rule"
  type        = string
}

variable "description" {
  description = "Description of the rule"
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes)."
  type        = string
}

variable "is_enabled" {
  description = "Whether the rule is enabled or disabled"
  type        = bool
  default     = true
}

variable "target_arn" {
  description = "The Amazon Resource Name (ARN) of the target resource (e.g., SQS queue ARN, Lambda ARN)"
  type        = string
}

variable "target_id" {
  description = "The unique target assignment ID. If missing, will generate a default one."
  type        = string
  default     = null
}

variable "input_json" {
  description = "Valid JSON text passed to the target. If this is used, the target will receive this constant JSON text."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
