import { Component } from '@angular/core';

@Component({
  selector: 'app-footer',
  template: `<footer class="footer">© 2025 Friend’s Pet List</footer>`,
  styles: [`
    .footer {
      text-align: center;
      padding: 1rem 0;
      background: #f0f0f0;
    }
  `]
})
export class FooterComponent {}