import { Module, DynamicModule } from '@nestjs/common';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { KafkaService } from './kafka.service';
import { KAFKA_BROKER } from './kafka.constants';

@Module({})
export class KafkaModule {
    static forRoot(groupId: string): DynamicModule {
        return {
            module: KafkaModule,
            imports: [
                ClientsModule.register([
                    {
                        name: 'KAFKA_CLIENT',
                        transport: Transport.KAFKA,
                        options: {
                            client: {
                                brokers: [KAFKA_BROKER],
                            },
                            consumer: {
                                groupId,
                            },
                        },
                    },
                ]),
            ],
            providers: [KafkaService],
            exports: [KafkaService],
        };
    }
}
