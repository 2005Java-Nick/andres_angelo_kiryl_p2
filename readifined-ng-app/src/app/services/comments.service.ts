import { Injectable } from '@angular/core';
import { CommentList } from '../types/CommentList';
@Injectable({
  providedIn: 'root'
})
export class CommentsService {

  constructor() { }

  commentsList: CommentList;

  setComments(comments: CommentList): void
  {
    this.commentsList = comments;
  }

  getComments(): CommentList {
    return this.commentsList;
  }

}
