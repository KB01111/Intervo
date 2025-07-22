// Root page - simple redirect to login
import { redirect } from 'next/navigation';

export default function RootPage() {
  // Server-side redirect to login page
  redirect('/login');
}
