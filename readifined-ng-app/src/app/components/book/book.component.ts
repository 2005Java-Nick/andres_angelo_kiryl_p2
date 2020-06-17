import { Component, OnInit } from '@angular/core';
import { BookList } from '../../types/BookList';
import { BookService } from '../../services/book.service';
import { GetBooksService } from 'src/app/services/get-books.service';

@Component({
  selector: 'app-book',
  templateUrl: './book.component.html',
  styleUrls: ['./book.component.css']
})
export class BookComponent implements OnInit {

  book: BookList;

  constructor(private bookService: BookService) {
    setInterval(() => {this.book = this.bookService.getCurrentBook(); }, 500);
  }

  ngOnInit(): void {
  }

}
