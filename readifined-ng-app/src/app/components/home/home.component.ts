import { Component, OnInit } from '@angular/core';
import { Book } from '../../types/book';
import { GenreListService } from '../../services/genre-list.service';
import { GenreService } from 'src/app/services/genre.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

 

  constructor(private gls: GenreListService, private gs: GenreService) { }

  ngOnInit(): void {
  }

  listGenres()
  {
    this.gs.getGenre().subscribe(
      (genre) => {this.gls.setGenre(genre);
                  console.log(this.gls.getGenre());
            }
    );
  }

  select(){
    console.log('Selected book');
  }
}
