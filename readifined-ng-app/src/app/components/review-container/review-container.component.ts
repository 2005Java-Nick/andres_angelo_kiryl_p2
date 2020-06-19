import { Component, OnInit, Input } from '@angular/core';
import { SubmitReviewService } from 'src/app/services/submit-review.service';

@Component({
  selector: 'app-review-container',
  templateUrl: './review-container.component.html',
  styleUrls: ['./review-container.component.css']
})
export class ReviewContainerComponent implements OnInit {

  id: string;
  title: string ;
  imgUrl: string ;
  author: string;
  price: string;
  @Input()
  signedIn: boolean;
  review = '';
  constructor(private submitReviewService: SubmitReviewService) { }

  ngOnInit(): void {
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

  saveText(){

  }

}
