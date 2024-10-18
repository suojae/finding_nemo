import { Injectable } from '@nestjs/common';

@Injectable()
export class LoginService {
    login(loginDto: any): string {
        // 간단한 로그인 로직 (여기서는 예시로 메시지 반환)
        return `User ${loginDto.username} logged in successfully`;
    }
}
