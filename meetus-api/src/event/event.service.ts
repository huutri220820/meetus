/* eslint-disable @typescript-eslint/ban-ts-comment */
import { EventDto } from './dto/event.dto';
import { Event, EventDocument } from 'src/shared/schema/event.schema';
import { UserDocument, User } from 'src/shared/schema/user.schema';
import { BadRequestException, ConflictException, Injectable, NotFoundException, NotImplementedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class EventService {
    constructor(@InjectModel(Event.name) private eventModel: Model<EventDocument>, @InjectModel(User.name) private userModel: Model<UserDocument>) {}

    async addEvent(event: EventDto, userId: string) {
        console.log('event', event);
        const place = 'VietNam';
        let user = await this.userModel.findById(userId);
        const eventDoc: Event = {
            location: {
                type: 'Point',
                coordinates: [event.location.longitude, event.location.latitude],
            },
            host: {
                userId: userId,
                displayName: user.displayName,
            },
            imageMain: event.imageMain,
            images: event.images,
            description: event.description,
            limit: event.limit,
            time: event.time,
            timeCreate: new Date(),
            place: place,
        };
        console.log(eventDoc);
        return new this.eventModel(eventDoc).save().then((doc) => {
            user.eventsHost.push({
                eventId: doc._id,
                timeCreate: new Date(),
            });
            user.save();
        });
    }

    async getEventById(eventId: string) {
        return this.eventModel.findById(eventId);
    }

    async getAllEvents(userId: string) {
        const usr = await this.userModel.findById(userId);
        if (!usr)
            throw new NotFoundException({
                message: 'User not found',
            });
        const eventMatch = usr.eventsJoin.map((event) => event.eventId);
        const eventSkip = usr.eventsSkip.map((event) => event.eventId);

        const result = await this.eventModel
            .find({
                _id: {
                    $nin: [...eventMatch, ...eventSkip],
                },
                count: {
                    $gt: -1,
                },
                'host.userId': {
                    $not: {
                        $regex: userId,
                    },
                },
            })
            .limit(10)
            .select('_id place imageMain host');

        return result.map((item) => {
            return {
                _id: item._id,
                place: item.place,
                imageMain: item.imageMain,
                userId: item.host.userId,
                displayName: item.host.displayName,
            };
        });
    }

    async getEventsInRange(userId: string, lon: number, lat: number) {
        // await this.eventModel.createIndexes({
        //     location: '2dsphere',
        // });
        const usr = await this.userModel.findById(userId);
        const eventMatch = usr.eventsJoin.map((event) => event.eventId);
        const eventSkip = usr.eventsSkip.map((event) => event.eventId);

        return this.eventModel
            .find({
                location: {
                    $nearSphere: {
                        $geometry: {
                            type: 'Point',
                            coordinates: [lon, lat],
                        },
                        $maxDistance: usr.range * 1000,
                    },
                },
                _id: {
                    $nin: [...eventMatch, ...eventSkip],
                },
                count: {
                    $gt: -1,
                },
                'host.userId': {
                    $not: {
                        $regex: userId,
                    },
                },
            })
            .limit(100)
            .select('_id place imageMain host');
    }

    async joinEvent(userId: string, eventId: string) {
        try {
            const usr = await this.userModel.findById(userId);
            const event = await this.eventModel.findById(eventId);
            console.log(event);

            if (usr.eventsJoin.find((event) => event.eventId == eventId)) {
                throw new ConflictException({
                    message: 'User already joined event',
                });
            }
            if (!event) {
                throw new BadRequestException({
                    message: 'Event not found',
                });
            }
            if (event.count >= event.limit) {
                throw new NotImplementedException({
                    message: 'Event limit exceeded',
                });
            }

            usr.eventsJoin.push({
                eventId: eventId,
                timeJoin: new Date(),
            });

            event.count += 1;
            if (event.limit >= event.count) event.count = -1;

            usr.save();
            event.save();
            return '200';
        } catch (err) {
            return err;
        }
    }

    async skipEvent(userId: string, eventId: string) {
        try {
            const usr = await this.userModel.findById(userId);
            if (usr.eventsSkip.find((event) => event.eventId == eventId)) {
                throw new BadRequestException({
                    message: 'User already skipped event',
                });
            }
            usr.eventsSkip.push({
                eventId: eventId,
                timeSkip: new Date(),
            });
            usr.save();
            return '200';
        } catch (err) {
            return err;
        }
    }
}
