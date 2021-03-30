import { User, UserDocument } from '../shared/schema/user.schema';
import { Injectable, NotFoundException } from '@nestjs/common';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import ProfileDto from './dto/profile.dto';
import { Event, EventDocument } from 'src/shared/schema/event.schema';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const Faker = require('faker/locale/vi');

@Injectable()
export class UserService {
    constructor(
        private firebaseAuth: FirebaseAuthenticationService,
        @InjectModel(User.name) private userModel: Model<UserDocument>,
        @InjectModel(Event.name) private eventModel: Model<EventDocument>,
    ) {}

    async getProfile(userId: string) {
        const profile = await this.userModel.findById(userId);

        const accountInfo = await this.firebaseAuth.getUser(userId);
        if (profile) {
            return {
                uid: profile._id,
                background: profile.background,
                bio: profile.bio,
                birthDate: profile.birthDate,
                eventsHost: profile.eventsHost,
                eventsJoin: profile.eventsJoin,
                eventsSkip: profile.eventsSkip,
                gender: profile.gender,
                job: profile.job,
                range: profile.range,
                displayName: accountInfo.displayName,
                email: accountInfo.email,
                photoURL: accountInfo.photoURL,
            };
        } else {
            return new this.userModel({
                _id: userId,
                background: Faker.image.imageUrl(425, 200),
                birthDate: Faker.date.past(2000),
                bio: Faker.lorem.sentence(10),
                gender: 'male',
                job: Faker.name.jobTitle(),
                displayName: accountInfo.displayName,
                email: accountInfo.email,
                range: 500,
            }).save();
        }
        // else throw new NotFoundException();
    }

    async getFirebaseAccountInfo(userId: string) {
        const accountInfo = await this.firebaseAuth.getUser(userId);
        if (accountInfo) return accountInfo;
        else throw new NotFoundException();
    }

    //create or update profile
    async updateProfile(profile: ProfileDto, userId: string): Promise<User> {
        const usr = await this.userModel.findById(userId);
        if (profile.displayName) {
            this.firebaseAuth.updateUser(userId, {
                displayName: profile.displayName,
            });
        } else {
            profile.displayName = (await this.firebaseAuth.auth.getUser(userId)).displayName;
        }
        // exit user => update
        if (usr) {
            return usr.update({
                ...profile,
            });
        } else {
            // add user
            const userProfile = new this.userModel({
                ...profile,
                _id: userId,
            });
            return userProfile.save();
        }
    }

    async search(userId: string, search: string, page: number, limit: number) {
        const [totalPage, listResult] = await Promise.all([
            this.userModel
                .find({
                    displayName: {
                        $regex: search,
                    },
                })
                .count(),
            this.userModel
                .find({
                    displayName: {
                        $regex: search,
                    },
                    _id: {
                        $not: {
                            $regex: userId,
                        },
                    },
                })
                .sort({
                    displayName: 1,
                })
                .skip(page > 0 ? (page - 1) * limit : 0)
                .limit(limit)
                .select('_id displayName'),
        ]);

        return {
            limit,
            page,
            totalPage: Math.ceil((totalPage - 1) / limit),
            listResult,
        };
    }

    async getEventMath(userId: string) {
        const eventsJoin = (await this.userModel.findById(userId)).eventsJoin.map((event) => event.eventId);

        return this.eventModel
            .find({
                _id: {
                    $in: eventsJoin,
                },
            })
            .select('_id place imageMain host');
    }

    async updateRange(userId: string, range: number) {
        return this.userModel.findByIdAndUpdate(userId, {
            range: range,
        });
    }
}
