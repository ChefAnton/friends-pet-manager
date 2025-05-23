import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Pet } from '../models/pet.model';
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class PetService {
  private base = `${environment.apiUrl}/pets`;

  constructor(private http: HttpClient) { }

  list(): Observable<Pet[]> {
    return this.http.get<Pet[]>(this.base);
  }

  get(id: string): Observable<Pet> {
    return this.http.get<Pet>(`${this.base}/${id}`);
  }

  create(p: Partial<Pet>): Observable<Pet> {
    return this.http.post<Pet>(this.base, p);
  }

  update(id: string, p: Partial<Pet>): Observable<Pet> {
    return this.http.put<Pet>(`${this.base}/${id}`, p);
  }

  delete(id: string): Observable<void> {
    return this.http.delete<void>(`${this.base}/${id}`);
  }
}