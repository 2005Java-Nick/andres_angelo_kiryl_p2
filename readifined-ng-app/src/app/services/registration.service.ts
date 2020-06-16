import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { User } from '../types/user';

@Injectable({
  providedIn: 'root'
})
export class RegistrationService {

  constructor(private http: HttpClient) { }

  private readonly REGISTER_URL = environment.serviceUrl + environment.registerEndpoint;

  register(lastname, firstname, username, password, email, dob, phone)
  {
    return this.http.post<User>
    (
      this.REGISTER_URL,
      'lastname=' + lastname +
      '&firstname=' + firstname +
      '&username=' + username +
      '&password=' + password +
      '&email=' + email +
      '&dob=' + dob +
      '&phone=' + phone, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
      });

  }
}
