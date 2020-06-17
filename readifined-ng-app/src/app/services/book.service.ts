import { Injectable } from '@angular/core';
import { Book } from '../types/Book';
@Injectable({
  providedIn: 'root'
})
export class BookService {

  constructor() { }

  currentBook: Book;

  setCurrentBook(book: Book): void
  {
    this.currentBook = book;
  }

  getCurrentBook(): Book {
    return this.currentBook;
  }

}
