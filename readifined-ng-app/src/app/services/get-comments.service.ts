import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { CommentList } from '../types/CommentList';
@Injectable({
  providedIn: 'root'
})
export class GetCommentsService {

  private readonly LOGIN_URL = environment.serviceUrl + environment.getCommentsEndpoint;

  constructor(private http: HttpClient) { }

  getComments(bookId)
  {
    return this.http.get<CommentList>
    (
      this.LOGIN_URL +
      '?bookId=' + bookId, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
      });
  }

}
