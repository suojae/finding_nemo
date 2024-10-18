import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);
    await app.listen(3003); // HAProxy에서 포트 3003으로 라우팅
}
bootstrap();
