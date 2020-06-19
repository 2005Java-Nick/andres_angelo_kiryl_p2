import { Component, OnInit } from '@angular/core';
import { CommentList } from 'src/app/types/CommentList';
import { CommentsService } from 'src/app/services/comments.service';

@Component({
  selector: 'app-comment',
  templateUrl: './comment.component.html',
  styleUrls: ['./comment.component.css']
})
export class CommentComponent implements OnInit {

  comments: CommentList;

  constructor(private commentsService: CommentsService) {
    setInterval(() => {this.comments = this.commentsService.getComments(); }, 500);
  }
  ngOnInit(): void {
  }

}
