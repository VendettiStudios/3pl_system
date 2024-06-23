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
