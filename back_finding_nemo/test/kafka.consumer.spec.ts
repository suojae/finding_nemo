import { Test, TestingModule } from '@nestjs/testing';
import { KafkaConsumerService } from '../kafka/kafka.consumer';
import { ClientKafka } from '@nestjs/microservices';
import { LOGIN_TOPIC, FEEDING_TOPIC } from '../kafka/kafka.constants';

describe('KafkaConsumerService', () => {
    let kafkaConsumerService: KafkaConsumerService;
    let kafkaClient: ClientKafka;

    beforeEach(async () => {
        const kafkaClientMock = {
            subscribeToResponseOf: jest.fn(), // 구독 함수 Mock 처리
            connect: jest.fn().mockResolvedValue(undefined), // 비동기 connect 함수 Mock 처리
        };

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                KafkaConsumerService,
                {
                    provide: ClientKafka, // ClientKafka에 대한 의존성 주입 명시
                    useValue: kafkaClientMock, // Kafka 클라이언트의 Mock 구현체 제공
                },
            ],
        }).compile();

        kafkaConsumerService = module.get<KafkaConsumerService>(KafkaConsumerService);
        kafkaClient = module.get<ClientKafka>(ClientKafka);
    });

    it('로그인 및 물고기 밥주기 토픽에 구독하는지 확인', async () => {
        const subscribeSpy = jest.spyOn(kafkaClient, 'subscribeToResponseOf');
        const connectSpy = jest.spyOn(kafkaClient, 'connect');

        await kafkaConsumerService.onModuleInit();

        expect(subscribeSpy).toHaveBeenCalledWith(LOGIN_TOPIC);
        expect(subscribeSpy).toHaveBeenCalledWith(FEEDING_TOPIC);
        expect(connectSpy).toHaveBeenCalled();
    });

    it('로그인 이벤트가 처리되는지 확인', () => {
        const payload = { user: 'test-user' };
        const consoleSpy = jest.spyOn(console, 'log');

        kafkaConsumerService.handleLoginEvent(payload);

        expect(consoleSpy).toHaveBeenCalledWith('Login Event:', payload);
    });

    it('물고기 밥주기 이벤트가 처리되는지 확인', () => {
        const payload = { fish: 'test-fish' };
        const consoleSpy = jest.spyOn(console, 'log');

        kafkaConsumerService.handleFeedingEvent(payload);

        expect(consoleSpy).toHaveBeenCalledWith('Feeding Event:', payload);
    });
});
