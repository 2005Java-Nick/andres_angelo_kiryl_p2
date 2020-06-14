import { Component, OnInit } from '@angular/core';
import { AuthenticationService } from 'src/app/services/authentication.service';
import { RoleService } from 'src/app/services/role.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  username: string;
  password: string;

  login()
  {
    this.authenticationService.authenticate(this.username, this.password).subscribe(
      (role) => {this.roleService.setCurrentRole(role); console.log(this.roleService.getCurrentRole()); }
    );
  }

  constructor(private authenticationService: AuthenticationService, private roleService: RoleService) { }

  ngOnInit(): void {
  }

}
