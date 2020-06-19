import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './components/login/login.component';
import { RegisterationComponent } from './components/registeration/registeration.component';
import { ForumsComponent } from './components/forums/forums.component';
import { NavBarComponent } from './components/nav-bar/nav-bar.component';
import { FooterComponent } from './components/footer/footer.component';
import { RoleComponent } from './components/role/role.component';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { AuthenticationInterceptor } from './AuthenticationInterceptor';
import { HomeComponent } from './components/home/home.component';
import { BookComponent } from './components/book/book.component';
import { DisplayBoxComponent } from './components/display-box/display-box.component';
import { ProfileComponent } from './components/profile/profile.component';
import { GenreListComponent } from './components/genre-list/genre-list.component';
import { BookContainerComponent } from './components/book-container/book-container.component';
import { ReviewContainerComponent } from './components/review-container/review-container.component';
@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegisterationComponent,
    ForumsComponent,
    NavBarComponent,
    FooterComponent,
    RoleComponent,
    HomeComponent,
    BookComponent,
    DisplayBoxComponent,
    ProfileComponent,
    GenreListComponent,
    BookContainerComponent,
    ReviewContainerComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    AppRoutingModule,
    FormsModule
  ],
  providers:
  [{
    provide: HTTP_INTERCEPTORS,
    useClass: AuthenticationInterceptor,
    multi: true
  }],
  bootstrap: [AppComponent]
})
export class AppModule { }
