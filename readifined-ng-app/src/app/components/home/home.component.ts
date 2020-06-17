import { Component, OnInit, Input } from '@angular/core';
import { Book } from '../../types/book';
import { GenreListService } from '../../services/genre-list.service';
import { GenreService } from 'src/app/services/genre.service';
import { Genre } from 'src/app/types/Genre';
import { GenreList } from 'src/app/types/GenreList';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  @Input()
  genres: GenreList;

  constructor(private gls: GenreListService, private gs: GenreService) { }

  ngOnInit(): void {
    this.gs.getGenre().subscribe(
      (genre) => {this.gls.setGenre(genre);
                  this.genres = genre;
            }
    );
  }

  select(){
    console.log('Selected book');
  }

  onSelect(g: Genre) {
    localStorage.setItem('selected-genre', g.genre);
    //go to book page
    console.log(g.genre);
  }
}
