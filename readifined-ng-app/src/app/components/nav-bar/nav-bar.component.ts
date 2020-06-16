import { Component, OnInit } from '@angular/core';
import { AuthenticationService } from 'src/app/services/authentication.service';
import { AuthorizationService } from 'src/app/services/authorization.service';
import { RoleService } from 'src/app/services/role.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrls: ['./nav-bar.component.css']
})
export class NavBarComponent implements OnInit {

  constructor(private authorizationService: AuthorizationService, private roleService: RoleService, private router: Router) { }

  ngOnInit(): void {
  }

  logOut()
  {
    localStorage.setItem('token', '');
    localStorage.setItem('username', '');
  }

  authorize()
  {
    this.authorizationService.authorize(localStorage.getItem('username')).subscribe(
      (role) => {this.roleService.setCurrentRole(role);
                 console.log(this.roleService.getCurrentRole());
                 localStorage.setItem('token', this.roleService.getCurrentRole().token);
                 if (!this.roleService.getCurrentRole().verified) {
                  this.router.navigate(['/login'], {replaceUrl: true});
                }
            }
    );
  }
}
