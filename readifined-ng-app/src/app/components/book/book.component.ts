import { Component, OnInit } from '@angular/core';
import { Book } from '../../types/Book';
import { BookService } from '../../services/book.service';

@Component({
  selector: 'app-book',
  templateUrl: './book.component.html',
  styleUrls: ['./book.component.css']
})
export class BookComponent implements OnInit {

  book: Book;

  constructor(private bookService: BookService) {
    setInterval(() => {this.book = this.bookService.getCurrentBook(); }, 500);
  }

  ngOnInit(): void {
  }

}
