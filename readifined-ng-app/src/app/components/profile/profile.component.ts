import { Component, OnInit } from '@angular/core';
import { Book } from '../../types/book';
import { BookService } from '../../services/book.service';
@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  books = Book;

  constructor(private book: BookService) { }

  ngOnInit(): void {
  }

}
