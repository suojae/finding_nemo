import { Module } from '@nestjs/common';
import { FeedingController } from './feeding.controller';
import { FeedingService } from './feeding.service';
import { KafkaModule } from '../../kafka/kafka.module';

@Module({
    imports: [
        KafkaModule.forRoot('fish-feeding-group'),  // Fish Feeding Service용 groupId
    ],
    controllers: [FeedingController],
    providers: [FeedingService],
})
export class AppModule {}
