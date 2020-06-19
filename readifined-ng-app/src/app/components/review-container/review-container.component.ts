import { Component, OnInit, Input } from '@angular/core';
import { SubmitReviewService } from 'src/app/services/submit-review.service';
import { CommentList } from 'src/app/types/CommentList';
import { GetCommentsService } from 'src/app/services/get-comments.service';
import { CommentsService } from 'src/app/services/comments.service';
import { Router } from '@angular/router';
import { ReversePipe } from 'src/app/pipes/reverse.pipe';
import { Observable, Subscription } from 'rxjs';
import { interval } from 'rxjs';
@Component({
  selector: 'app-review-container',
  templateUrl: './review-container.component.html',
  styleUrls: ['./review-container.component.css'],
  providers: [ReversePipe]
})
export class ReviewContainerComponent implements OnInit {

  @Input()
  commentsList: CommentList;
  id: string;
  title: string;
  imgUrl: string ;
  author: string;
  price: string;
  @Input()
  signedIn: boolean;
  review = '';
  @Input()
  chatText: string;
  isHidden: boolean;
  sub: Subscription;

  constructor(private submitReviewService: SubmitReviewService,
              private gcs: GetCommentsService,
              private cs: CommentsService,
              private reverse: ReversePipe,
              private router: Router) { }

  ngOnInit(): void {
    if (localStorage.getItem('username') == null)
    {
      this.isHidden = false;
    }else
    {
      this.isHidden = true ;
    }
    this.title = localStorage.getItem('book');
    this.imgUrl = localStorage.getItem('coverimg');
    this.author = localStorage.getItem('author');
    this.price = localStorage.getItem('price');
    this.id = localStorage.getItem('bookid');
    if (localStorage.getItem('username') !== null)
    {
      this.signedIn = true;
    }else
    {
      this.signedIn = false;
    }
    this.sub = interval(1000).subscribe((val) => { this.refreshChat(); });
  }

  refreshChat()
  {
    this.gcs.getComments(this.id).subscribe(
      (result) => {this.cs.setComments(result);
                   this.commentsList = result;
            }
    );
  }

  loadImage(): string {
    if (this.imgUrl.includes('null'))
    {
      return '#';
    }
    else{
      return this.imgUrl;
    }
  }

  submitReview(value: string): void
  {
    this.review = value;
    console.log(this.review);
    this.submitReviewService.submitReview(this.review, '2', this.id).subscribe(
    (response) => {
          console.log(response);
       }
    );
  }

  delay(ms: number) {
    return new Promise( resolve => setTimeout(resolve, ms) );
  }

  appendText(text){
    this.chatText = this.chatText + '<br>' + text;
  }

  reRoute(link){
    localStorage.setItem('lastpage', '/bookreview');
    this.router.navigate([link]);
  }

}
