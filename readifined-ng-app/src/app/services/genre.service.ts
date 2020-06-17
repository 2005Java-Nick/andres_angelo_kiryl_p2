import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { GenreList } from '../types/GenreList';
@Injectable({
  providedIn: 'root'
})
export class GenreService {

  private readonly LOGIN_URL = environment.serviceUrl + environment.getGenreEndpoint;

  constructor(private http: HttpClient) { }

  getGenre()
  {
    return this.http.get<GenreList>
    (
      this.LOGIN_URL,
       {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
      });
  }

}
