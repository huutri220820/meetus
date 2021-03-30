import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type EventDocument = Event & Document;

@Schema({
    versionKey: false,
    autoIndex: true,
})
export class Event {
    @Prop({
        required: true,
        type: {
            coordinates: {
                type: [Number], // [<longitude>, <latitude>]
            },
            location: {
                type: String,
                enum: ['Point'],
            },
        },
    })
    location: {
        coordinates: number[];
        type: string;
    };

    @Prop({
        default: '',
    })
    place?: string;

    @Prop()
    time: Date;

    @Prop()
    timeCreate: Date;

    @Prop({
        default: false,
    })
    isCompleted?: boolean;

    @Prop({ default: [] })
    participants?: [{ userId: string; time: Date }];

    @Prop({
        default: 5,
    })
    limit: number;

    @Prop({
        default: 1,
    })
    count?: number; // -1 is full

    @Prop({
        type: {
            userId: String,
            displayName: String,
        },
    })
    host: {
        userId: string;
        displayName: string;
    }; //user id

    @Prop({
        default: '',
    })
    description?: string;

    @Prop()
    imageMain: string;

    @Prop({
        default: [],
    })
    images?: [string];

    @Prop({
        default: '',
    })
    chatRoomId?: string;
}
export const EventSchema = SchemaFactory.createForClass(Event);

//create index location
EventSchema.index({ location: '2dsphere' });

//TODO check room id
EventSchema.pre('save', async function (next) {
    try {
        next();
    } catch (err) {
        next(err);
    }
});
