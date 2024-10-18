import { Test, TestingModule } from '@nestjs/testing';
import { KafkaService } from '../kafka/kafka.service';
import { ClientKafka } from '@nestjs/microservices';

describe('KafkaService', () => {
    let kafkaService: KafkaService;
    let kafkaClient: ClientKafka;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                KafkaService,
                {
                    provide: 'KAFKA_CLIENT',
                    useValue: {
                        emit: jest.fn(),
                        connect: jest.fn(),
                    },
                },
            ],
        }).compile();

        kafkaService = module.get<KafkaService>(KafkaService);
        kafkaClient = module.get<ClientKafka>('KAFKA_CLIENT');
    });

    // 테스트 이름: Kafka 브로커에 연결되는지 확인
    it('Kafka 브로커에 연결되는지 확인', async () => {
        const connectSpy = jest.spyOn(kafkaClient, 'connect');

        await kafkaService.onModuleInit();

        expect(connectSpy).toHaveBeenCalled();
    });

    // 테스트 이름: Kafka 토픽에 메시지가 전송되는지 확인
    it('Kafka 토픽에 메시지가 전송되는지 확인', () => {
        const topic = 'test-topic';
        const message = { key: 'value' };
        const emitSpy = jest.spyOn(kafkaClient, 'emit');

        kafkaService.sendMessage(topic, message);

        expect(emitSpy).toHaveBeenCalledWith(topic, message);
    });
});
