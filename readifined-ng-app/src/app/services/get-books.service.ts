import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { BookList } from '../types/BookList';

@Injectable({
  providedIn: 'root'
})
export class GetBooksService {
  private readonly LOGIN_URL = environment.serviceUrl + environment.getBooksEndpoint;

  constructor(private http: HttpClient) { }

  getBooks(genre)
  {
    return this.http.get<BookList>
    (
      this.LOGIN_URL +
      '?genre=' + genre, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
      });
  }
}
