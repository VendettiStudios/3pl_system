import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MetricsController } from './metrics.controller'; // Add this import
import { MetricsService } from './metrics.service'; // Add this import

@Module({
  imports: [],
  controllers: [AppController, MetricsController],
  providers: [AppService, MetricsService],
})
export class AppModule {}
