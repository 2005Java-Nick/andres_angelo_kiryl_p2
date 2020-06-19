import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Routes, RouterModule } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { ForumsComponent } from './components/forums/forums.component';
import { HomeComponent } from './components/home/home.component';
import { ProfileComponent } from './components/profile/profile.component';
import { RegisterationComponent } from './components/registeration/registeration.component';
import { BookComponent } from './components/book/book.component';
import { BookContainerComponent } from './components/book-container/book-container.component';
import { ReviewContainerComponent } from './components/review-container/review-container.component';

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'home', component: HomeComponent },
  { path: 'forums', component: ForumsComponent},
  { path: 'profile', component: ProfileComponent },
  { path: 'registeration', component: RegisterationComponent},
  { path: 'book', component: BookContainerComponent},
  { path: 'bookreview', component: ReviewContainerComponent},
  { path: '', redirectTo: '/login', pathMatch: 'full'}
];

@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    RouterModule.forRoot(routes)
  ],
  exports: [RouterModule]
})
export class AppRoutingModule { }
