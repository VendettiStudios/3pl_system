#!/bin/bash

# List of microservices directories
services=(
  "BIS/nest-bis/bis-service"
  "CRM/nest-crm/crm-service"
  "ERP/nest-erp/erp-service"
  "TMS/nest-tms/tms-service"
  "WMS/IMS/nest-ims/ims-service"
  "WMS/OMS/nest-oms/oms-service"
  "WMS/WO/nest-wo/wo-service"
)

# Function to update service files
update_service_files() {
  local service_dir=$1
  cat <<EOF > "$service_dir/src/metrics.service.ts"
import { Injectable } from '@nestjs/common';
import { collectDefaultMetrics, Registry, Histogram } from 'prom-client';

@Injectable()
export class MetricsService {
  private readonly registry: Registry;
  public readonly httpRequestDurationMicroseconds: Histogram<string>;

  constructor() {
    this.registry = new Registry();
    collectDefaultMetrics({ register: this.registry });

    this.httpRequestDurationMicroseconds = new Histogram({
      name: 'http_request_duration_seconds',
      help: 'Duration of HTTP requests in seconds',
      labelNames: ['method', 'route', 'code'],
      buckets: [0.1, 0.2, 0.5, 1, 1.5],
    });

    this.registry.registerMetric(this.httpRequestDurationMicroseconds);
  }

  getMetrics() {
    return this.registry.metrics();
  }
}
EOF

  cat <<EOF > "$service_dir/src/metrics.controller.ts"
import { Controller, Get, Res } from '@nestjs/common';
import { Response } from 'express';
import { MetricsService } from './metrics.service';

@Controller('metrics')
export class MetricsController {
  constructor(private readonly metricsService: MetricsService) {}

  @Get()
  async getMetrics(@Res() response: Response): Promise<void> {
    response.set('Content-Type', 'text/plain');
    response.end(await this.metricsService.getMetrics());
  }
}
EOF

  # Add imports and providers to app.module.ts if not already present
  sed -i '' 's/import { AppController } from .\/app.controller;/import { AppController } from .\/app.controller; import { MetricsController } from .\/metrics.controller;/' "$service_dir/src/app.module.ts"
  sed -i '' 's/import { AppService } from .\/app.service;/import { AppService } from .\/app.service; import { MetricsService } from .\/metrics.service;/' "$service_dir/src/app.module.ts"
  sed -i '' 's/controllers: \[AppController\]/controllers: \[AppController, MetricsController\]/' "$service_dir/src/app.module.ts"
  sed -i '' 's/providers: \[AppService\]/providers: \[AppService, MetricsService\]/' "$service_dir/src/app.module.ts"
}

# Loop through each service and install prom-client
for service in "${services[@]}"; do
  echo "Installing prom-client in $service..."
  cd "$service" || exit
  npm install prom-client
  cd - || exit

  echo "Updating $service to expose metrics..."
  update_service_files "$service"
done

echo "prom-client installation and metrics setup completed for all services."
