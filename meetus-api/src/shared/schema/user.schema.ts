import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type UserDocument = User & Document;

@Schema({
    versionKey: false,
})
export class User {
    @Prop()
    _id: string; //UID

    @Prop()
    displayName: string;

    @Prop()
    birthDate: Date;

    @Prop()
    job: string;

    @Prop()
    gender: string;

    @Prop()
    bio: string;

    @Prop()
    background: string;

    @Prop()
    eventsJoin: [{ eventId: string; timeJoin: Date }];

    @Prop()
    eventsSkip: [{ eventId: string; timeSkip: Date }];

    @Prop()
    eventsHost: [{ eventId: string; timeCreate: Date }];

    @Prop({
        type: Number,
        default: 5,
    })
    range: number;
}
export const UserSchema = SchemaFactory.createForClass(User);
