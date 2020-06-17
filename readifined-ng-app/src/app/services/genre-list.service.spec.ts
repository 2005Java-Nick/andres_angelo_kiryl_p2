import { TestBed } from '@angular/core/testing';

import { GenreListService } from './genre-list.service';

describe('GenreListService', () => {
  let service: GenreListService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(GenreListService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
