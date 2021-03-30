import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { ChatRoom, ChatRoomDocument } from 'src/shared/schema/chart-room.schema';
import { MessageData } from 'src/shared/types/message.type';

@Injectable()
export class ChatService {
    constructor(@InjectModel(ChatRoom.name) private chatroomModel: Model<ChatRoomDocument>) {}
    async createChatRoom(eventId: string) {
        return new this.chatroomModel({
            eventId: eventId,
        }).save();
    }

    async sendMessage(chatRoomId: string, userId: string, userName: string, content: string) {
        const message: MessageData = {
            content: content,
            created: new Date(),
            senderId: userId,
            senderName: userName,
        };
        const currentChat = await this.chatroomModel.findById(chatRoomId);
        currentChat.message.push(message);
        currentChat.save();
    }

    async pullMessages(chatRoomId: string) {
        return (await this.chatroomModel.findById(chatRoomId)).message;
    }

    async getAllChatRoom(userId: string) {
        return this.chatroomModel.find({});
    }
}
