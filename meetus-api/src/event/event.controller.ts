import { Body, Controller, Get, Param, Post, Req, ParseIntPipe, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import AppRequest from 'src/shared/types/request.type';
import { EventDto } from './dto/event.dto';
import { EventService } from './event.service';

@ApiTags('event')
@ApiBearerAuth()
@Controller('event')
export class EventController {
    constructor(private readonly evenService: EventService) {}

    @ApiQuery({
        name: 'lat',
        description: 'Vĩ độ',
    })
    @ApiQuery({
        name: 'lon',
        description: 'Kinh độ',
    })
    @Get('/')
    async getEvents(@Req() req: AppRequest, @Query('lon', ParseIntPipe) lon: number, @Query('lat', ParseIntPipe) lat: number) {
        return this.evenService.getEventsInRange(req.token.uid, lon, lat);
    }

    @Get('/all')
    async getAllEvents(@Req() req: AppRequest) {
        return this.evenService.getAllEvents(req.token.uid);
    }

    @Get('/detail/:id')
    async getEventByID(@Param('id') id: string) {
        return this.evenService.getEventById(id);
    }

    @Post('/')
    async createEvent(@Req() req: AppRequest, @Body() event: EventDto) {
        return this.evenService.addEvent(event, req.token.uid);
    }

    @Get('/join/:id')
    async joinEvent(@Req() req: AppRequest, @Param('id') id: string) {
        return this.evenService.joinEvent(req.token.uid, id);
    }

    @Get('/skip/:id')
    async skipEvent(@Req() req: AppRequest, @Param('id') id: string) {
        return this.evenService.skipEvent(req.token.uid, id);
    }
}
