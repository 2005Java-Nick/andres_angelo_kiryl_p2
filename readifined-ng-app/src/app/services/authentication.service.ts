import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { Role } from '../types/Role';
@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {
  constructor(private http: HttpClient) { }

  private readonly LOGIN_URL = environment.serviceUrl + environment.loginEndpoint;

  authenticate(username, password)
  {
    return this.http.post<Role>
    (
      this.LOGIN_URL,
      'username=' + username + '&' +
      'password=' + password, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
      });
  }
}
