import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { Role } from '../types/Role';

@Injectable({
  providedIn: 'root'
})
export class AuthorizationService {

  constructor(private http: HttpClient) { }

  private readonly LOGIN_URL = environment.serviceUrl + environment.authorizeEndpoint;

  authorize(username)
  {
    localStorage.setItem('username', username);
    return this.http.post<Role>
    (
      this.LOGIN_URL,
      'username=' + username, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
      });
  }

}
