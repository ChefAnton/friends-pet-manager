import { Component, OnInit } from '@angular/core';
import { FriendService } from '../../services/friend.service';
import { Friend } from '../../models/friend.model';
import { Router } from '@angular/router';

@Component({
  selector: 'app-friend-list',
  templateUrl: './friend-list.component.html',
  styleUrls: ['./friend-list.component.scss']
})
export class FriendListComponent implements OnInit {
  friends: Friend[] = [];

  constructor(
    private svc: FriendService,
    private router: Router
  ) {}

  ngOnInit() {
    this.load();
  }

  load() {
    this.svc.list().subscribe(f => this.friends = f);
  }

  edit(id: string) {
    this.router.navigate(['/friends/edit', id]);
  }

  delete(id: string) {
    if (confirm('Delete this friend?')) {
      this.svc.delete(id).subscribe(() => this.load());
    }
  }
}