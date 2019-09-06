variable "dashboard_name" {
  type = string
  description = "Cloudwatch dashboard name"
}

variable "lb_name" {
  type = string
  description = "Load Balancer name to monitor"
}

variable "app_lb" {
  type = string
  description = "Write here 'true' if you're attaching this dashboard to an Application Load Balaner rather than a Classic Load Balaner (default 'false')"
  default = false
}

variable "period" {
  type = string
  description = "Period to update the chart (in seconds, default 60)"
  default = "300"
}

variable "evaluation_periods" {
  default = "2"
}

variable "alarm_arns" {
  type = list(string)
  description = "The ARNs of the actions to take in case of ALARM status"
  default = []
}

variable "ok_arns" {
  type = list(string)
  description = "The ARNs of the actions to take in case of OK status"
  default = []
}

variable "alarm_treat_missing_data" {
  type = string
  description = "How to treat missing data (default: ignore)"
  default = "ignore"
}
