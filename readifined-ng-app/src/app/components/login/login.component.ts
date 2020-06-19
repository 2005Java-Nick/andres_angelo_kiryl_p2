import { Component, OnInit } from '@angular/core';
import { AuthenticationService } from 'src/app/services/authentication.service';
import { RoleService } from 'src/app/services/role.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  username: string;
  password: string;
  isvalid: boolean;

  login()
  {
    this.authenticationService.authenticate(this.username, this.password).subscribe(
      (role) => {this.roleService.setCurrentRole(role);
                 console.log(this.roleService.getCurrentRole());
                 localStorage.setItem('token', this.roleService.getCurrentRole().token);
                 if (this.roleService.getCurrentRole().verified && localStorage.getItem('lastpage') == null) {
                    this.router.navigate(['/home'], {replaceUrl: true});
                 }else
                 {
                    this.router.navigate([localStorage.getItem('lastpage')], {replaceUrl: true});
                 }
            }
    );
  }

  constructor(private authenticationService: AuthenticationService, private roleService: RoleService, private router: Router) { }

  ngOnInit(): void {
  }

}
