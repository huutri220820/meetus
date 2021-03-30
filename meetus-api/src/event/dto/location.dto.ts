import { ApiProperty } from '@nestjs/swagger';
import { IsLatitude, IsLongitude } from 'class-validator';

export class LocationDto {
    @IsLongitude()
    @ApiProperty({
        description: 'Kinh độ',
        default: 0,
    })
    longitude: number; //kinh độ

    @IsLatitude()
    @ApiProperty({
        description: 'Vĩ độ',
        default: 0,
    })
    latitude: number; //vĩ đô
}
