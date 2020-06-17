import { Injectable } from '@angular/core';
import { Book } from '../types/Book';
import { BookList } from '../types/BookList';
@Injectable({
  providedIn: 'root'
})
export class BookService {

  constructor() { }

  currentBook: BookList;

  setCurrentBook(book: BookList): void
  {
    this.currentBook = book;
  }

  getCurrentBook(): BookList {
    return this.currentBook;
  }

}
