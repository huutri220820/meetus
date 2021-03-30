import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { Allow, IsDateString, IsNumber, IsString, ValidateNested } from 'class-validator';
import { LocationDto } from './location.dto';

export class EventDto {
    @ApiProperty()
    @ValidateNested({
        each: true,
    })
    @Type(() => LocationDto)
    location: LocationDto;

    @ApiProperty({
        default: 10,
    })
    @IsNumber()
    limit: number;

    @ApiProperty()
    @IsDateString()
    time: Date;

    @ApiProperty({
        required: false,
    })
    @Allow()
    description: string;

    @ApiProperty()
    @IsString()
    imageMain: string; //url image

    @ApiProperty()
    @Allow()
    images: [string];
}
