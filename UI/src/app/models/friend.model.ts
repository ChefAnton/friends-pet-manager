export interface Friend {
  friendId: string;
  userId: string;
  firstName: string;
  lastName: string;
  gender?: 'Male' | 'Female' | 'Other';
  dob?: string;
  description?: string;
}