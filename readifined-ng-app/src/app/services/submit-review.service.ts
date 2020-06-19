import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class SubmitReviewService {

  constructor(private http: HttpClient, ) { }

  private readonly REGISTER_URL = environment.serviceUrl + environment.submitReviewEndpoint;

  submitReview(review, rating, bookid)
  {
    return this.http.post
    (
      this.REGISTER_URL,
      'review=' + review +
      '&rating=' + rating +
      '&bookid=' + bookid, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
      });

  }
}
