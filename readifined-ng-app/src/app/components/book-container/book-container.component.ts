import { Component, OnInit, Input } from '@angular/core';
import { BookList } from '../../types/BookList';
import { Router } from '@angular/router';
import { GetBooksService } from 'src/app/services/get-books.service';
import { BookService } from 'src/app/services/book.service';
import { Book } from 'src/app/types/book';
@Component({
  selector: 'app-book-container',
  templateUrl: './book-container.component.html',
  styleUrls: ['./book-container.component.css']
})
export class BookContainerComponent implements OnInit {
  @Input()
  books: BookList;
  title: string;
  img: string;
  show: boolean;

  constructor(private gbs: GetBooksService, private bs: BookService, private router: Router) { }

  ngOnInit(): void {
    this.show = false;
    this.title = localStorage.getItem('selected-genre');
    this.gbs.getBooks(this.title).subscribe(
      (book) => {this.bs.setCurrentBook(book);
                 this.books = book;
            }
    );
  }

  loadImage(b: Book): string {
    if (b.coverImg.includes('null'))
    {
      return '#';
    }
    else{
      return b.coverImg;
    }
  }

  onSelect(b: Book) {
    localStorage.setItem('selected-genre', b.title);
    console.log(b.id);
    console.log(b.title);
    console.log(b.price);
    console.log(b.coverImg);
  }
}
