import { Component, OnInit } from '@angular/core';
import { AuthenticationService } from 'src/app/services/authentication.service';
import { AuthorizationService } from 'src/app/services/authorization.service';
import { RoleService } from 'src/app/services/role.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-forums',
  templateUrl: './forums.component.html',
  styleUrls: ['./forums.component.css']
})
export class ForumsComponent implements OnInit {

  textbox: string;

  constructor(private authorizationService: AuthorizationService, private roleService: RoleService, private router: Router) { }

  submitComment(){
    console.log('Comment submitted!');
  }

  ngOnInit(): void {
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
