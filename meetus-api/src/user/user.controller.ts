import { Body, Controller, Get, Param, ParseIntPipe, Post, Put, Query, Req } from '@nestjs/common';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import AppRequest from 'src/shared/types/request.type';
import ProfileDto from './dto/profile.dto';
import { UserService } from './user.service';

@ApiTags('user')
@ApiBearerAuth()
@Controller('user')
export class UserController {
    constructor(private readonly userService: UserService) {}

    @ApiQuery({
        name: 'page',
        required: false,
        type: Number,
        example: 1,
    })
    @ApiQuery({
        name: 'limit',
        required: false,
        type: Number,
        example: 10,
    })
    @ApiQuery({
        name: 'search',
        required: true,
        type: String,
        example: 'abc',
    })
    @Get('/search')
    async searchUser(
        @Req() req: AppRequest,
        @Query('search') search: string,
        @Query('page', ParseIntPipe) page = 1,
        @Query('limit', ParseIntPipe) limit = 1,
    ) {
        return this.userService.search(req.token.uid, search, page, limit);
    }

    @Get('/profile')
    async getUsers(@Req() req: AppRequest) {
        return this.userService.getProfile(req.token.uid);
    }

    // first login or update profile
    @Post('/profile')
    async updateProfile(@Body() profile: ProfileDto, @Req() req: AppRequest) {
        return this.userService.updateProfile(profile, req.token.uid);
    }

    @Get('/account')
    async getAccountFirebase(@Req() req: AppRequest) {
        return this.userService.getFirebaseAccountInfo(req.token.uid);
    }

    @Put('/range')
    async updateRange(@Req() req: AppRequest, @Query('range', ParseIntPipe) range: number) {
        return this.userService.updateRange(req.token.uid, range);
    }
}
