import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-forums',
  templateUrl: './forums.component.html',
  styleUrls: ['./forums.component.css']
})
export class ForumsComponent implements OnInit {

  textbox: string;

  constructor() { }

  submitComment(){
    console.log('Comment submitted!');
  }

  ngOnInit(): void {
  }

}
