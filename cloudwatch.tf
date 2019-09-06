resource "aws_cloudwatch_dashboard" "main" {
   dashboard_name = "${var.dashboard_name}"
   count = "${var.app_lb ? 0 : 1}"

   dashboard_body = <<EOF
   {
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 21,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/ELB", "SurgeQueueLength", "LoadBalancerName", "${var.lb_name}", { "period": "${var.period}" } ],
                    [ ".", "RequestCount", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "BackendConnectionErrors", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "HTTPCode_ELB_5XX", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "Latency", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "HTTPCode_Backend_3XX", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "HTTPCode_Backend_4XX", ".", ".", { "stat": "Sum", "period": "${var.period}" } ]
                ],
                "region": "${data.aws_region.current.name}",
                "title": "${var.dashboard_name}"
            }
        }
    ]
  }
  EOF
}

resource "aws_cloudwatch_dashboard" "main_alb" {
   dashboard_name = "${var.dashboard_name}"
   count = "${var.app_lb ? 1 : 0}"

   dashboard_body = <<EOF
   {
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 21,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${var.lb_name}", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "ActiveConnectionCount", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "HTTPCode_ELB_4XX_Count", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "TargetResponseTime", ".", ".", { "stat": "Average", "period": "${var.period}" } ],
                    [ ".", "HTTPCode_Target_3XX_Count", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "HTTPCode_Target_4XX_Count", ".", ".", { "stat": "Sum", "period": "${var.period}" } ],
                    [ ".", "RequestCount", ".", ".", { "stat": "Sum", "period": "${var.period}" } ]
                ],
                "region": "${data.aws_region.current.name}",
                "title": "${var.dashboard_name}"
            }
        }
    ]
  }
  EOF
}

resource "aws_cloudwatch_metric_alarm" "alb_RequestCount" {
    count                       = var.app_lb ? 1 : 0
    alarm_name                  = "${var.dashboard_name}-alb_RequestCount-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "RequestCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.alb_thresholds["RequestCount"]
    period                      = var.period
    namespace                   = "AWS/ApplicationELB"
    statistic                   = "Sum"
    alarm_description           = "ALB RequestCount over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "ActiveConnectionCount" {
    count                       = var.app_lb ? 1 : 0
    alarm_name                  = "${var.dashboard_name}-ActiveConnectionCount-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "ActiveConnectionCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.alb_thresholds["ActiveConnectionCount"]
    period                      = var.period
    namespace                   = "AWS/ApplicationELB"
    statistic                   = "Sum"
    alarm_description           = "ALB ActiveConnectionCount over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_ELB_4XX_Count" {
    count                       = var.app_lb ? 1 : 0
    alarm_name                  = "${var.dashboard_name}-HTTPCode_ELB_4XX_Count-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "HTTPCode_ELB_4XX_Count"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.alb_thresholds["HTTPCode_ELB_4XX_Count"]
    period                      = var.period
    namespace                   = "AWS/ApplicationELB"
    statistic                   = "Sum"
    alarm_description           = "ALB HTTPCode_ELB_4XX_Count over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "TargetResponseTime" {
    count                       = var.app_lb ? 1 : 0
    alarm_name                  = "${var.dashboard_name}-TargetResponseTime-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "TargetResponseTime"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.alb_thresholds["TargetResponseTime"]
    period                      = var.period
    namespace                   = "AWS/ApplicationELB"
    statistic                   = "Sum"
    alarm_description           = "ALB TargetResponseTime over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_Target_3XX_Count" {
    count                       = var.app_lb ? 1 : 0
    alarm_name                  = "${var.dashboard_name}-HTTPCode_Target_3XX_Count-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "HTTPCode_Target_3XX_Count"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.alb_thresholds["HTTPCode_Target_3XX_Count"]
    period                      = var.period
    namespace                   = "AWS/ApplicationELB"
    statistic                   = "Sum"
    alarm_description           = "ALB HTTPCode_Target_3XX_Count over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_Target_4XX_Count" {
    count                       = var.app_lb ? 1 : 0
    alarm_name                  = "${var.dashboard_name}-HTTPCode_Target_4XX_Count-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "HTTPCode_Target_4XX_Count"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.alb_thresholds["HTTPCode_Target_4XX_Count"]
    period                      = var.period
    namespace                   = "AWS/ApplicationELB"
    statistic                   = "Sum"
    alarm_description           = "ALB HTTPCode_Target_4XX_Count over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "elb_RequestCount" {
    count                       = var.app_lb ? 0 : 1
    alarm_name                  = "${var.dashboard_name}-elb_RequestCount-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "RequestCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.elb_thresholds["RequestCount"]
    period                      = var.period
    namespace                   = "AWS/ELB"
    statistic                   = "Sum"
    alarm_description           = "ELB RequestCount over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "SurgeQueueLength" {
    count                       = var.app_lb ? 0 : 1
    alarm_name                  = "${var.dashboard_name}-SurgeQueueLength-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "RequestCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.elb_thresholds["SurgeQueueLength"]
    period                      = var.period
    namespace                   = "AWS/ELB"
    statistic                   = "Sum"
    alarm_description           = "ELB SurgeQueueLength over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "BackendConnectionErrors" {
    count                       = var.app_lb ? 0 : 1
    alarm_name                  = "${var.dashboard_name}-BackendConnectionErrors-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "RequestCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.elb_thresholds["BackendConnectionErrors"]
    period                      = var.period
    namespace                   = "AWS/ELB"
    statistic                   = "Sum"
    alarm_description           = "ELB BackendConnectionErrors over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_ELB_5XX" {
    count                       = var.app_lb ? 0 : 1
    alarm_name                  = "${var.dashboard_name}-HTTPCode_ELB_5XX-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "RequestCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.elb_thresholds["HTTPCode_ELB_5XX"]
    period                      = var.period
    namespace                   = "AWS/ELB"
    statistic                   = "Sum"
    alarm_description           = "ELB HTTPCode_ELB_5XX over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "Latency" {
    count                       = var.app_lb ? 0 : 1
    alarm_name                  = "${var.dashboard_name}-Latency-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "RequestCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.elb_thresholds["Latency"]
    period                      = var.period
    namespace                   = "AWS/ELB"
    statistic                   = "Sum"
    alarm_description           = "ELB Latency over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_Backend_3XX" {
    count                       = var.app_lb ? 0 : 1
    alarm_name                  = "${var.dashboard_name}-HTTPCode_Backend_3XX-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "RequestCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.elb_thresholds["HTTPCode_Backend_3XX"]
    period                      = var.period
    namespace                   = "AWS/ELB"
    statistic                   = "Sum"
    alarm_description           = "ELB HTTPCode_Backend_3XX over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_Backend_4XX" {
    count                       = var.app_lb ? 0 : 1
    alarm_name                  = "${var.dashboard_name}-HTTPCode_Backend_4XX-alarm"
    comparison_operator         = "GreaterThanOrEqualToThreshold"
    metric_name                 = "RequestCount"
    evaluation_periods          = var.evaluation_periods
    threshold                   = local.elb_thresholds["HTTPCode_Backend_4XX"]
    period                      = var.period
    namespace                   = "AWS/ELB"
    statistic                   = "Sum"
    alarm_description           = "ELB HTTPCode_Backend_4XX over"
    alarm_actions               = var.alarm_arns
    ok_actions                  = var.ok_arns
    treat_missing_data          = var.alarm_treat_missing_data

    dimensions = {
        LoadBalancer = var.lb_name
    }

    tags = {}
}