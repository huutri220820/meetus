import { MessageData } from './../types/message.type';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type ChatRoomDocument = ChatRoom & Document;

@Schema({
    versionKey: false,
})
export class ChatRoom {
    @Prop()
    eventId: string;

    @Prop({
        default: [],
    })
    message: MessageData[];
}
export const ChatRoomSchema = SchemaFactory.createForClass(ChatRoom);
