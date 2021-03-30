import { ApiProperty } from '@nestjs/swagger';
import { Allow, IsDateString, IsEnum, IsNumber, IsString } from 'class-validator';

class ProfileDto {
    @ApiProperty({
        required: false,
    })
    @Allow()
    displayName?: string;

    @ApiProperty({
        description: '"dd-mm-yyyy"',
    })
    @IsDateString()
    birthDate: Date;

    @ApiProperty()
    @IsString()
    job: string;

    @ApiProperty({
        description: '"male" or "female"',
    })
    @IsEnum(['male', 'female'])
    gender: string;

    @ApiProperty({
        required: false,
    })
    @Allow()
    bio: string;

    @ApiProperty({
        required: false,
    })
    @Allow()
    background: string;

    @IsNumber()
    @ApiProperty({
        default: 5,
    })
    range: number;
}

export default ProfileDto;
