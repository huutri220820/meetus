import { AuthMiddleware } from './shared/auth.middleware';
import { SharedModule } from './shared/shared.module';
import { MiddlewareConsumer, Module, NestModule, RequestMethod } from '@nestjs/common';
import { FirebaseAdminModule } from '@aginix/nestjs-firebase-admin';
import { UserModule } from './user/user.module';
import * as admin from 'firebase-admin';
import firebaseCredential from './shared/config/firebase';
import { MongooseModule } from '@nestjs/mongoose';
import { MONGO_URL } from './shared/config/mongodb';
import { EventModule } from './event/event.module';
import { ChatModule } from './chat/chat.module';

@Module({
    imports: [
        UserModule,
        SharedModule,
        FirebaseAdminModule.forRoot({
            credential: admin.credential.cert(firebaseCredential as any),
        }),
        MongooseModule.forRoot(MONGO_URL),
        EventModule,
        ChatModule,
    ],
    controllers: [],
    providers: [],
})
export class AppModule implements NestModule {
    configure(consumer: MiddlewareConsumer) {
        consumer.apply(AuthMiddleware).forRoutes({
            path: '*',
            method: RequestMethod.ALL,
        });
    }
}
