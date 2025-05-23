import { Component, OnInit } from '@angular/core';
import { PetService } from '../../services/pet.service';
import { Pet } from '../../models/pet.model';
import { Router } from '@angular/router';

@Component({
  selector: 'app-pet-list',
  templateUrl: './pet-list.component.html',
  styleUrls: ['./pet-list.component.scss']
})
export class PetListComponent implements OnInit {
  pets: Pet[] = [];

  constructor(
    private svc: PetService,
    private router: Router
  ) {}

  ngOnInit() {
    this.load();
  }

  load() {
    this.svc.list().subscribe(p => this.pets = p);
  }

  edit(id: string) {
    this.router.navigate(['/pets/edit', id]);
  }

  delete(id: string) {
    if (confirm('Delete this pet?')) {
      this.svc.delete(id).subscribe(() => this.load());
    }
  }
}