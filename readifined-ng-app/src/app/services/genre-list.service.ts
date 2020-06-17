import { Injectable } from '@angular/core';
import { GenreList } from '../types/GenreList';

@Injectable({
  providedIn: 'root'
})
export class GenreListService {

  genreList: GenreList;

  setGenre(genre: GenreList): void
  {
    this.genreList = genre;
  }

  getGenre(): GenreList{
    return this.genreList;
  }


  constructor() { }
}
