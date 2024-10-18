import { Controller, Post, Body } from '@nestjs/common';
import { FeedingService } from './feeding.service';

@Controller('feeding')
export class FeedingController {
    constructor(private readonly feedingService: FeedingService) {}

    @Post()
    async feedFish(@Body() feedDto: any) {
        return this.feedingService.feedFish(feedDto);
    }
}
