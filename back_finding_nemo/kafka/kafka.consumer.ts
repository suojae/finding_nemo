import { Injectable, OnModuleInit } from '@nestjs/common';
import { ClientKafka } from '@nestjs/microservices';
import { LOGIN_TOPIC, FEEDING_TOPIC } from './kafka.constants';

@Injectable()
export class KafkaConsumerService implements OnModuleInit {
  constructor(private readonly kafkaClient: ClientKafka) {}

  onModuleInit() {
    // 토픽 구독 설정
    this.kafkaClient.subscribeToResponseOf(LOGIN_TOPIC);
    this.kafkaClient.subscribeToResponseOf(FEEDING_TOPIC);
    this.kafkaClient.connect();
  }

  // 로그인 이벤트 처리 함수
  handleLoginEvent(payload: any) {
    console.log('Login Event:', payload);
  }

  // 물고기 밥주기 이벤트 처리 함수
  handleFeedingEvent(payload: any) {
    console.log('Feeding Event:', payload);
  }
}
