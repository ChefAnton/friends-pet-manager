import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { PetService } from '../../services/pet.service';
import { FriendService } from '../../services/friend.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Friend } from '../../models/friend.model';

@Component({
  selector: 'app-pet-form',
  templateUrl: './pet-form.component.html',
  styleUrls: ['./pet-form.component.scss']
})
export class PetFormComponent implements OnInit {
  form = this.fb.group({
    friendId: ['', Validators.required],
    petType: ['', Validators.required],
    breed: [''],
    name: ['', Validators.required],
    dob: [''],
    description: ['']
  });
  friends: Friend[] = [];
  isEdit = false;
  id?: string;

  constructor(
    private fb: FormBuilder,
    private petSvc: PetService,
    private friendSvc: FriendService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit() {
    this.friendSvc.list().subscribe(f => this.friends = f);
    this.id = this.route.snapshot.paramMap.get('id') || undefined;
    if (this.id) {
      this.isEdit = true;
      this.petSvc.get(this.id).subscribe(p => this.form.patchValue(p));
    }
  }

  submit() {
    if (this.form.invalid) return;
    const data = this.form.value;
    const obs = this.isEdit
      ? this.petSvc.update(this.id!, data)
      : this.petSvc.create(data);
    obs.subscribe(() => this.router.navigate(['/pets']));
  }
}