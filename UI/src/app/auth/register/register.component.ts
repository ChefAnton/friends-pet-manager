import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent {
  form = this.fb.group({
    username: ['', Validators.required],
    password: ['', [Validators.required, Validators.minLength(8)]],
    confirm: ['', Validators.required]
  });
  error = '';

  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private router: Router
  ) {}

  submit() {
    if (this.form.invalid) return;
    const { username, password, confirm } = this.form.value;
    if (password !== confirm) {
      this.error = 'Passwords do not match';
      return;
    }
    this.auth.register(username!, password!)
      .subscribe({
        next: () => this.router.navigate(['/login']),
        error: err => this.error = 'Registration failed'
      });
  }
}