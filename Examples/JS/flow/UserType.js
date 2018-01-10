//  @flow
//
//  UserType.js
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

import type { PlankDate, PlankURI } from './runtime.flow.js';
import type { ImageType } from './ImageType.js';

export type UserEmailIntervalType = 
  | 'unset'
  | 'immediate'
  | 'daily'
;

export type UserType = $Shape<{|
  +email_interval: UserEmailIntervalType,
  +last_name: ?string,
  +id: ?string,
  +image: ?ImageType,
  +counts: ?{ +[string]: number } /* Integer */,
  +created_at: ?PlankDate,
  +first_name: ?string,
  +bio: ?string,
  +username: ?string,
|}> & {
  id: string
};

