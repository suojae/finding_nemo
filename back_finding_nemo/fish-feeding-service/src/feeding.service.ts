import { Injectable } from '@nestjs/common';

@Injectable()
export class FeedingService {
    feedFish(feedDto: any) {
        const { fishId, foodAmount } = feedDto;
        // 물고기에게 먹이를 주는 로직
        return `Fish ${fishId} fed successfully with ${foodAmount} units of food`;
    }
}
