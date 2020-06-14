import { Injectable } from '@angular/core';
import { Role } from '../types/Role';

@Injectable({
  providedIn: 'root'
})
export class RoleService {

  currentRole: Role;

  setCurrentRole(role: Role): void
  {
    this.currentRole = role;
  }

  getCurrentRole(): Role{
    return this.currentRole;
  }

  constructor() { }
}
