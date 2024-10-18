import { Module } from '@nestjs/common';
import { LoginController } from './login.controller';
import { LoginService } from './login.service';
import { KafkaModule } from '../../kafka/kafka.module';

@Module({
    imports: [
        KafkaModule.forRoot('user-login-group'),  // User Login Service용 groupId
    ],
    controllers: [LoginController],
    providers: [LoginService],
})
export class AppModule {}
