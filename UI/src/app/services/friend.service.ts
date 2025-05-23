import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Friend } from '../models/friend.model';
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class FriendService {
  private base = `${environment.apiUrl}/friends`;

  constructor(private http: HttpClient) { }

  list(): Observable<Friend[]> {
    return this.http.get<Friend[]>(this.base);
  }

  get(id: string): Observable<Friend> {
    return this.http.get<Friend>(`${this.base}/${id}`);
  }

  create(f: Partial<Friend>): Observable<Friend> {
    return this.http.post<Friend>(this.base, f);
  }

  update(id: string, f: Partial<Friend>): Observable<Friend> {
    return this.http.put<Friend>(`${this.base}/${id}`, f);
  }

  delete(id: string): Observable<void> {
    return this.http.delete<void>(`${this.base}/${id}`);
  }
}