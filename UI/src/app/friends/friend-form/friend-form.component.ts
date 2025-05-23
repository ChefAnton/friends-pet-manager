import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { FriendService } from '../../services/friend.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-friend-form',
  templateUrl: './friend-form.component.html',
  styleUrls: ['./friend-form.component.scss']
})
export class FriendFormComponent implements OnInit {
  form = this.fb.group({
    firstName: ['', Validators.required],
    lastName: ['', Validators.required],
    gender: [''],
    dob: [''],
    description: ['']
  });
  isEdit = false;
  id?: string;

  constructor(
    private fb: FormBuilder,
    private svc: FriendService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit() {
    this.id = this.route.snapshot.paramMap.get('id') || undefined;
    if (this.id) {
      this.isEdit = true;
      this.svc.get(this.id).subscribe(f => this.form.patchValue(f));
    }
  }

  submit() {
    if (this.form.invalid) return;
    const data = this.form.value;
    const obs = this.isEdit
      ? this.svc.update(this.id!, data)
      : this.svc.create(data);
    obs.subscribe(() => this.router.navigate(['/friends']));
  }
}