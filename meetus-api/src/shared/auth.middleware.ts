import { ForbiddenException, Injectable, NestMiddleware } from '@nestjs/common';
import { NextFunction, Response } from 'express';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin';
import AppRequest from 'src/shared/types/request.type';

@Injectable()
export class AuthMiddleware implements NestMiddleware {
    constructor(private readonly fireAuth: FirebaseAuthenticationService) {}

    async use(req: AppRequest, res: Response, next: NextFunction) {
        console.log(new Date().toUTCString(), ` - ${req.ip} ${req.method}: ${req.path}`);
        const token = await req.headers.authorization;
        if (token) {
            try {
                req.token = await this.fireAuth.verifyIdToken(token.replace('Bearer ', ''));
                next();
            } catch (err) {
                throw new ForbiddenException(err);
            }
        } else {
            throw new ForbiddenException();
        }
    }
}
