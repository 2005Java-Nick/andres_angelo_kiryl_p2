import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { Role } from '../types/Role';

@Injectable({
  providedIn: 'root'
})
export class RegistrationService {

  constructor(private http: HttpClient) { }

  private readonly REGISTER_URL = environment.serviceUrl + environment.registerEndpoint;

  register(firstname, lastname, username, password, email, dob, phone, author)
  {
    localStorage.setItem('username', username);
    return this.http.post<Role>
    (
      this.REGISTER_URL,
      'lastname=' + lastname +
      '&firstname=' + firstname +
      '&username=' + username +
      '&password=' + password +
      '&email=' + email +
      '&dob=' + dob +
      '&phone=' + phone +
      '&role=' + author, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
      });

  }
}
