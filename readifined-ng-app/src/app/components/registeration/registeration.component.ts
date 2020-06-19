import { Component, OnInit } from '@angular/core';
import { RegistrationService } from '../../services/registration.service';
import { RoleService } from 'src/app/services/role.service';
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
  author: boolean;

  constructor(private registrationService: RegistrationService, private roleService: RoleService, private router: Router) { }

  toggleAuthor(){
    this.author = !this.author;
    console.log(this.author);
  }

  register()
  {
    this.registrationService.register(this.firstname,
      this.lastname, this.username, this.password, this.email, this.dob, this.phone, this.author).subscribe(
        (role) => {this.roleService.setCurrentRole(role);
                   console.log(this.roleService.getCurrentRole());
                   localStorage.setItem('token', this.roleService.getCurrentRole().token);
                   if (!this.roleService.getCurrentRole().verified) {
                    this.router.navigate(['/registeration'], {replaceUrl: true});
                  }else{
                    if (localStorage.getItem('lastpage') == null)
                    {
                      this.router.navigate(['/home'], {replaceUrl: true});
                    }
                    else
                    {
                      this.router.navigate([localStorage.getItem('lastpage')], {replaceUrl: true});
                    }
                  }
              }
      );
  }

  ngOnInit(): void {
  }

}
