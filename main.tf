module "event_table" {
  source = "./modules/dynamodb"

  table_name = "events"
  hash_key   = "eventId"

  tags = {
    Environment = var.environment
    Purpose     = "eventsManagement"
  }
}

module "order_table" {
  source = "./modules/dynamodb"

  table_name = "orders"
  hash_key   = "orderId"

  tags = {
    Environment = var.environment
    Purpose     = "eventsManagement"
  }
}

module "stock_update_queue" {
  source     = "./modules/sqs"
  queue_name = "stock-update-queue"

  tags = {
    Environment = var.environment
    Purpose     = "StockUpdates"
  }
}
module "manage_order_queue" {
  source     = "./modules/sqs"
  queue_name = "manage-order-queue"

  tags = {
    Environment = var.environment
    Purpose     = "ManageOrder"
  }
}

module "stock_check_scheduler" {
  source = "./modules/scheduler"

  name                = "stock-check-cron"
  description         = "Triggers stock check every 5 minutes"
  schedule_expression = "rate(5 minutes)"
  target_arn          = module.stock_update_queue.queue_arn

  input_json = jsonencode({
    action = "scheduled_stock_check"
    source = "eventbridge_scheduler"
  })

  tags = {
    Environment = var.environment
  }
}

resource "aws_sqs_queue_policy" "allow_eventbridge" {
  queue_url = module.stock_update_queue.queue_url
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.stock_update_queue.queue_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.stock_check_scheduler.rule_arn
          }
        }
      }
    ]
  })
}
