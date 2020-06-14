import { Component, OnInit } from '@angular/core';
import { Role } from 'src/app/types/Role';
import { RoleService } from 'src/app/services/role.service';

@Component({
  selector: 'app-role',
  templateUrl: './role.component.html',
  styleUrls: ['./role.component.css']
})
export class RoleComponent implements OnInit {

  role: Role;

  constructor(private roleService: RoleService) {
    setInterval(() => {this.role = this.roleService.getCurrentRole(); } , 500);
   }

  ngOnInit(): void {
  }

}
