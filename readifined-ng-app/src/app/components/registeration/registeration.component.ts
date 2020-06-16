import { Component, OnInit } from '@angular/core';
import { RegistrationService } from '../../services/registration.service';
import { UserService } from 'src/app/services/user.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-registeration',
  templateUrl: './registeration.component.html',
  styleUrls: ['./registeration.component.css']
})
export class RegisterationComponent implements OnInit {

  lastname: string;
  firstname: string;
  username: string;
  password: string;
  email: string;
  dob: Date;
  phone: number;

  constructor(private registrationService: RegistrationService, private userService: UserService, private router: Router) { }

  ngOnInit(): void {
  }

}
