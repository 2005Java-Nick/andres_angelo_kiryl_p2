import { Component, OnInit } from '@angular/core';
import { GenreList } from '../../types/GenreList';
import { GenreListService } from '../../services/genre-list.service';
@Component({
  selector: 'app-genre-list',
  templateUrl: './genre-list.component.html',
  styleUrls: ['./genre-list.component.css']
})
export class GenreListComponent implements OnInit {
  genre: GenreList;

  constructor(private genreListService: GenreListService) {
    setInterval(() => {this.genre = this.genreListService.getGenre(); }, 500);
   }


  ngOnInit(): void {
  }

}
