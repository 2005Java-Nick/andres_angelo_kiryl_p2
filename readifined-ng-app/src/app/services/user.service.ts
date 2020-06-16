import { Injectable } from '@angular/core';
import { User } from '../types/user';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  currentUser: User;

  setCurrentUser(user: User): void
  {
    this.currentUser = user;
  }

  getCurrentUser(): User
  {
    return this.currentUser;
  }
  constructor() { }
}
