import { Request } from 'express';
import { auth } from 'firebase-admin';

type AppRequest = Request & {
    token: auth.DecodedIdToken;
};

export default AppRequest;
