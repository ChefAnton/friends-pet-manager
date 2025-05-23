import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { LoginComponent } from './auth/login/login.component';
import { RegisterComponent } from './auth/register/register.component';
import { FriendListComponent } from './friends/friend-list/friend-list.component';
import { FriendFormComponent } from './friends/friend-form/friend-form.component';
import { PetListComponent } from './pets/pet-list/pet-list.component';
import { PetFormComponent } from './pets/pet-form/pet-form.component';
import { AuthGuard } from './guards/auth.guard';

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  {
    path: '',
    canActivate: [AuthGuard],
    children: [
      { path: 'friends', component: FriendListComponent },
      { path: 'friends/new', component: FriendFormComponent },
      { path: 'friends/edit/:id', component: FriendFormComponent },
      { path: 'pets', component: PetListComponent },
      { path: 'pets/new', component: PetFormComponent },
      { path: 'pets/edit/:id', component: PetFormComponent },
      { path: '', redirectTo: 'friends', pathMatch: 'full' }
    ]
  },
  { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }